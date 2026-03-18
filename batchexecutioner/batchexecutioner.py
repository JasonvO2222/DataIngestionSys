from confluent_kafka import Consumer, KafkaException, KafkaError
import clickhouse_connect
import sys
import json
import signal
import time
import logging

time.sleep(10)

# setting up kafka consumer
conf = {'bootstrap.servers': 'broker1:9092,broker2:9092,broker3:9092', 'group.id': 'batchexecutioner', 'auto.offset.reset': 'latest'}

consumer = Consumer(conf)

running = True

def basic_consume_loop(consumer, topics):
    try:
        consumer.subscribe(topics)

        while running:
            msg = consumer.poll(timeout=1.0)
            if msg is None: continue

            if msg.error():
                if msg.error().code() == KafkaError._PARTITION_EOF:
                    # End of partition event
                    sys.stderr.write('%% %s [%d] reached end at offset %d\n' %
                                     (msg.topic(), msg.partition(), msg.offset()))
                elif msg.error():
                    raise KafkaException(msg.error())
            else:
                msg_process(msg)
    finally:
        # Close down consumer to commit final offsets.
        consumer.close()


# shutdown handler
def shutdown(signum, frame):
    global running
    print("Shutdown signal received...")
    running = False

signal.signal(signal.SIGTERM, shutdown)
signal.signal(signal.SIGINT, shutdown)

# set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')
logger = logging.getLogger(__name__)

# setting up clickhouse connect
clients = [
    clickhouse_connect.get_client(host='server1', username='executioner', password='execute'),
    clickhouse_connect.get_client(host='server2', username='executioner', password='execute'),
    clickhouse_connect.get_client(host='server3', username='executioner', password='execute'),
]

def msg_process(msg):
    data = json.loads(msg.value().decode("utf-8"))
    machine_id = data['machine_id']
    sys_type = data['sys']
    logger.info(f"Performing batch execution for {sys_type} on machine {machine_id}")
    match sys_type:
        case 'aio':
            for c in clients:
                c.command(f'''
                    ALTER TABLE default.aio_getevents_local
                    UPDATE total_time = total_time + (
                        SELECT additional_time FROM default.aio_staging_local
                        WHERE default.aio_staging_local.machine_id = machine_id
                        AND default.aio_staging_local.ts_s = ts_s
                        AND default.aio_staging_local.pid = pid
                        AND default.aio_staging_local.tid = tid
                        AND default.aio_staging_local.aioctx = aioctx
                    )
                    WHERE machine_id = {machine_id}
                    AND (ts_s, pid, tid, aioctx) IN (
                        SELECT ts_s, pid, tid, aioctx FROM default.aio_staging_local WHERE machine_id = {machine_id}
                    )
                ''')
            clients[0].command(f'''
                INSERT INTO default.aio_getevents (machine_id, ts_s, pid, tid, aioctx, total_time)
                    SELECT
                        default.aio_staging.machine_id,
                        default.aio_staging.ts_s,
                        default.aio_staging.pid,
                        default.aio_staging.tid,
                        default.aio_staging.aioctx,
                        default.aio_staging.additional_time
                    FROM default.aio_staging
                    GLOBAL LEFT JOIN default.aio_getevents
                        USING (machine_id, ts_s, pid, tid, aioctx)
                    WHERE default.aio_staging.machine_id = {machine_id}
                    AND default.aio_getevents.ts_s IS NULL
            ''')
            for c in clients:
                c.command(f'ALTER TABLE default.aio_staging_local DELETE WHERE machine_id = {machine_id}')

        case 'vfs':
            for c in clients:
                c.command(f'''
                    ALTER TABLE default.vfs_local
                    UPDATE total_time = total_time + (
                        SELECT additional_time FROM default.vfs_staging_local
                        WHERE default.vfs_staging_local.machine_id = machine_id
                        AND default.vfs_staging_local.ts_s = ts_s
                        AND default.vfs_staging_local.pid = pid
                        AND default.vfs_staging_local.tid = tid
                        AND default.vfs_staging_local.fs_magic = fs_magic
                        AND default.vfs_staging_local.device_id = device_id
                        AND default.vfs_staging_local.inode_id = inode_id
                        AND default.vfs_staging_local.op = op
                    )
                    WHERE machine_id = {machine_id}
                    AND (ts_s, pid, tid, fs_magic, device_id, inode_id, op) IN (
                        SELECT ts_s, pid, tid, fs_magic, device_id, inode_id, op FROM default.vfs_staging_local WHERE machine_id = {machine_id}
                    )
                ''')
            clients[0].command(f'''
                INSERT INTO default.vfs (machine_id, ts_s, pid, tid, fs_magic, device_id, inode_id, op, total_time)
                    SELECT
                        default.vfs_staging.machine_id,
                        default.vfs_staging.ts_s,
                        default.vfs_staging.pid,
                        default.vfs_staging.tid,
                        default.vfs_staging.fs_magic,
                        default.vfs_staging.device_id,
                        default.vfs_staging.inode_id,
                        default.vfs_staging.op,
                        default.vfs_staging.additional_time
                    FROM default.vfs_staging
                    GLOBAL LEFT JOIN default.vfs
                        USING (machine_id, ts_s, pid, tid, fs_magic, device_id, inode_id, op)
                    WHERE default.vfs_staging.machine_id = {machine_id}
                    AND default.vfs.ts_s IS NULL
            ''')
            for c in clients:
                c.command(f'ALTER TABLE default.vfs_staging_local DELETE WHERE machine_id = {machine_id}')

        case 'futex':
            for c in clients:
                c.command(f'''
                    ALTER TABLE default.futex_wait_local
                    UPDATE total_time = total_time + (
                        SELECT additional_time FROM default.futex_wait_staging_local
                        WHERE default.futex_wait_staging_local.machine_id = machine_id
                        AND default.futex_wait_staging_local.ts_s = ts_s
                        AND default.futex_wait_staging_local.pid = pid
                        AND default.futex_wait_staging_local.tid = tid
                        AND default.futex_wait_staging_local.futex_key_addr = futex_key_addr
                        AND default.futex_wait_staging_local.futex_key_word = futex_key_word
                        AND default.futex_wait_staging_local.futex_key_offset = futex_key_offset
                    )
                    WHERE machine_id = {machine_id}
                    AND (ts_s, pid, tid, futex_key_addr, futex_key_word, futex_key_offset) IN (
                        SELECT ts_s, pid, tid, futex_key_addr, futex_key_word, futex_key_offset FROM default.futex_wait_staging_local WHERE machine_id = {machine_id}
                    )
                ''')
            clients[0].command(f'''
                INSERT INTO default.futex_wait (machine_id, ts_s, pid, tid, futex_key_addr, futex_key_word, futex_key_offset, total_time)
                    SELECT
                        default.futex_wait_staging.machine_id,
                        default.futex_wait_staging.ts_s,
                        default.futex_wait_staging.pid,
                        default.futex_wait_staging.tid,
                        default.futex_wait_staging.futex_key_addr,
                        default.futex_wait_staging.futex_key_word,
                        default.futex_wait_staging.futex_key_offset,
                        default.futex_wait_staging.additional_time
                    FROM default.futex_wait_staging
                    GLOBAL LEFT JOIN default.futex_wait
                        USING (machine_id, ts_s, pid, tid, futex_key_addr, futex_key_word, futex_key_offset)
                    WHERE default.futex_wait_staging.machine_id = {machine_id}
                    AND default.futex_wait.ts_s IS NULL
            ''')
            for c in clients:
                c.command(f'ALTER TABLE default.futex_wait_staging_local DELETE WHERE machine_id = {machine_id}')

        case 'muxio':
            for c in clients:
                c.command(f'''
                    ALTER TABLE default.muxio_wait_local
                    UPDATE total_time = total_time + (
                        SELECT additional_time FROM default.muxio_staging_local
                        WHERE default.muxio_staging_local.machine_id = machine_id
                        AND default.muxio_staging_local.ts_s = ts_s
                        AND default.muxio_staging_local.pid = pid
                        AND default.muxio_staging_local.tid = tid
                        AND default.muxio_staging_local.is_epoll = is_epoll
                        AND default.muxio_staging_local.poll_id = poll_id
                    )
                    WHERE machine_id = {machine_id}
                    AND (ts_s, pid, tid, is_epoll, poll_id) IN (
                        SELECT ts_s, pid, tid, is_epoll, poll_id FROM default.muxio_staging_local WHERE machine_id = {machine_id}
                    )
                ''')
            clients[0].command(f'''
                INSERT INTO default.muxio_wait (machine_id, ts_s, pid, tid, is_epoll, poll_id, total_time)
                    SELECT
                        default.muxio_staging.machine_id,
                        default.muxio_staging.ts_s,
                        default.muxio_staging.pid,
                        default.muxio_staging.tid,
                        default.muxio_staging.is_epoll,
                        default.muxio_staging.poll_id,
                        default.muxio_staging.additional_time
                    FROM default.muxio_staging
                    GLOBAL LEFT JOIN default.muxio_wait
                        USING (machine_id, ts_s, pid, tid, is_epoll, poll_id)
                    WHERE default.muxio_staging.machine_id = {machine_id}
                    AND default.muxio_wait.ts_s IS NULL
            ''')
            for c in clients:
                c.command(f'ALTER TABLE default.muxio_staging_local DELETE WHERE machine_id = {machine_id}')



# run
basic_consume_loop(consumer, ['upsert_pending'])





