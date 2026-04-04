-- =============================================================
-- AIO
-- =============================================================

-- ================ getevents
CREATE TABLE IF NOT EXISTS default.aio_getevents_local
(
    machine_id      UInt32,
    ts_s            DateTime(3),
    pid             UInt32,
    tid             UInt32,
    aioctx          UInt64,
    total_time      UInt64,
    total_requests  UInt64
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY ts_s;

CREATE TABLE IF NOT EXISTS default.aio_getevents AS default.aio_getevents_local
ENGINE = Distributed(cluster_3s_1r, default, aio_getevents_local, machine_id);

CREATE TABLE IF NOT EXISTS default.aio_getevents_queue
(
    machine_id      UInt32,
    ts_s            DateTime(3),
    pid             UInt32,
    tid             UInt32,
    aioctx          UInt64,
    total_time      UInt64,
    total_requests  UInt64
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'aio_getevents', 'clickhouse_aio_getevents', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.aio_getevents_mv TO default.aio_getevents AS
SELECT * FROM default.aio_getevents_queue;

-- ================ submit
CREATE TABLE IF NOT EXISTS default.aio_submit_local
(
    machine_id      UInt32,
    ts_s            DateTime(3),
    pid             UInt32,
    tid             UInt32,
    aioctx          UInt64,
    total_requests  UInt64
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY ts_s;

CREATE TABLE IF NOT EXISTS default.aio_submit AS default.aio_submit_local
ENGINE = Distributed(cluster_3s_1r, default, aio_submit_local, machine_id);

CREATE TABLE IF NOT EXISTS default.aio_submit_queue
(
    machine_id      UInt32,
    ts_s            DateTime(3),
    pid             UInt32,
    tid             UInt32,
    aioctx          UInt64,
    total_requests  UInt64
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'aio_submit', 'clickhouse_aio_submit', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.aio_submit_mv TO default.aio_submit AS
SELECT * FROM default.aio_submit_queue;

-- ================ file
CREATE TABLE IF NOT EXISTS default.aio_file_local
(
    machine_id  UInt32,
    ts_s        DateTime(3),
    aioctx      UInt64,
    isreg       UInt8,
    fs_magic    Nullable(UInt32),
    device_id   Nullable(UInt32),
    inode_id    Nullable(UInt64),
    part0       Nullable(UInt64),
    bdev        Nullable(UInt64),
    mode        UInt8,
    hist0 UInt32, hist1 UInt32, hist2 UInt32, hist3 UInt32,
    hist4 UInt32, hist5 UInt32, hist6 UInt32, hist7 UInt32
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY ts_s;

CREATE TABLE IF NOT EXISTS default.aio_file AS default.aio_file_local
ENGINE = Distributed(cluster_3s_1r, default, aio_file_local, machine_id);

CREATE TABLE IF NOT EXISTS default.aio_file_queue
(
    machine_id  UInt32,
    ts_s        DateTime(3),
    aioctx      UInt64,
    isreg       UInt8,
    fs_magic    Nullable(UInt32),
    device_id   Nullable(UInt32),
    inode_id    Nullable(UInt64),
    part0       Nullable(UInt64),
    bdev        Nullable(UInt64),
    mode        UInt8,
    hist0 UInt32, hist1 UInt32, hist2 UInt32, hist3 UInt32,
    hist4 UInt32, hist5 UInt32, hist6 UInt32, hist7 UInt32
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'aio_file', 'clickhouse_aio_file', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.aio_file_mv TO default.aio_file AS
SELECT * FROM default.aio_file_queue;


-- =============================================================
-- DISCOVERY
-- =============================================================

CREATE TABLE IF NOT EXISTS default.tcp_discovery_local
(
    local_machine_id    UInt32,
    local_inode_id      UInt64,
    remote_machine_id   UInt32,
    remote_inode_id     UInt64,
    inserted_at         DateTime(3)
) ENGINE = MergeTree
PARTITION BY local_machine_id
ORDER BY inserted_at;

CREATE TABLE IF NOT EXISTS default.tcp_discovery AS default.tcp_discovery_local
ENGINE = Distributed(cluster_3s_1r, default, tcp_discovery_local, local_machine_id);

CREATE TABLE IF NOT EXISTS default.tcp_discovery_queue
(
    local_machine_id    UInt32,
    local_inode_id      UInt64,
    remote_machine_id   UInt32,
    remote_inode_id     UInt64,
    inserted_at         DateTime(3)
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'tcp_discovery', 'clickhouse_tcp_discovery', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.tcp_discovery_mv TO default.tcp_discovery AS
SELECT * FROM default.tcp_discovery_queue;


-- =============================================================
-- FUTEX
-- =============================================================

-- ================ wait
CREATE TABLE IF NOT EXISTS default.futex_wait_local
(
    machine_id          UInt32,
    ts_s                DateTime(3),
    pid                 UInt32,
    tid                 UInt32,
    futex_key_addr      UInt64,
    futex_key_word      UInt64,
    futex_key_offset    UInt32,
    total_requests      UInt64,
    total_time          UInt64,
    hist0 UInt32, hist1 UInt32, hist2 UInt32, hist3 UInt32,
    hist4 UInt32, hist5 UInt32, hist6 UInt32, hist7 UInt32
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY ts_s;

CREATE TABLE IF NOT EXISTS default.futex_wait AS default.futex_wait_local
ENGINE = Distributed(cluster_3s_1r, default, futex_wait_local, machine_id);

CREATE TABLE IF NOT EXISTS default.futex_wait_queue
(
    machine_id          UInt32,
    ts_s                DateTime(3),
    pid                 UInt32,
    tid                 UInt32,
    futex_key_addr      UInt64,
    futex_key_word      UInt64,
    futex_key_offset    UInt32,
    total_requests      UInt64,
    total_time          UInt64,
    hist0 UInt32, hist1 UInt32, hist2 UInt32, hist3 UInt32,
    hist4 UInt32, hist5 UInt32, hist6 UInt32, hist7 UInt32
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'futex_wait', 'clickhouse_futex_wait', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.futex_wait_mv TO default.futex_wait AS
SELECT * FROM default.futex_wait_queue;

-- ================ wake
CREATE TABLE IF NOT EXISTS default.futex_wake_local
(
    machine_id          UInt32,
    ts_s                DateTime(3),
    pid                 UInt32,
    tid                 UInt32,
    futex_key_addr      UInt64,
    futex_key_word      UInt64,
    futex_key_offset    UInt32,
    total_requests      UInt64,
    successful_count    UInt64
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY ts_s;

CREATE TABLE IF NOT EXISTS default.futex_wake AS default.futex_wake_local
ENGINE = Distributed(cluster_3s_1r, default, futex_wake_local, machine_id);

CREATE TABLE IF NOT EXISTS default.futex_wake_queue
(
    machine_id          UInt32,
    ts_s                DateTime(3),
    pid                 UInt32,
    tid                 UInt32,
    futex_key_addr      UInt64,
    futex_key_word      UInt64,
    futex_key_offset    UInt32,
    total_requests      UInt64,
    successful_count    UInt64
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'futex_wake', 'clickhouse_futex_wake', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.futex_wake_mv TO default.futex_wake AS
SELECT * FROM default.futex_wake_queue;


-- =============================================================
-- IOWAIT
-- =============================================================
CREATE TABLE IF NOT EXISTS default.iowait_local
(
    machine_id  UInt32,
    ts_s        DateTime(3),
    pid         UInt32,
    tid         UInt32,
    part0       UInt64,
    bdev        UInt64,
    total_time  UInt64,
    sector_cnt  UInt32,
    total_requests UInt32,
    hist0 UInt32, hist1 UInt32, hist2 UInt32, hist3 UInt32,
    hist4 UInt32, hist5 UInt32, hist6 UInt32, hist7 UInt32
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY ts_s;

CREATE TABLE IF NOT EXISTS default.iowait AS default.iowait_local
ENGINE = Distributed(cluster_3s_1r, default, iowait_local, machine_id);

CREATE TABLE IF NOT EXISTS default.iowait_queue
(
    machine_id  UInt32,
    ts_s        DateTime(3),
    pid         UInt32,
    tid         UInt32,
    part0       UInt64,
    bdev        UInt64,
    total_time  UInt64,
    sector_cnt  UInt32,
    total_requests UInt32,
    hist0 UInt32, hist1 UInt32, hist2 UInt32, hist3 UInt32,
    hist4 UInt32, hist5 UInt32, hist6 UInt32, hist7 UInt32
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'iowait', 'clickhouse_iowait', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.iowait_mv TO default.iowait AS
SELECT * FROM default.iowait_queue;


-- =============================================================
-- MUXIO (MUX)
-- =============================================================

-- ================ wait
CREATE TABLE IF NOT EXISTS default.muxio_wait_local
(
    machine_id      UInt32,
    ts_s            DateTime(3),
    pid             UInt32,
    tid             UInt32,
    is_epoll        BOOLEAN,
    poll_id         UInt64,
    total_time      UInt64,
    total_requests  UInt64
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY ts_s;

CREATE TABLE IF NOT EXISTS default.muxio_wait AS default.muxio_wait_local
ENGINE = Distributed(cluster_3s_1r, default, muxio_wait_local, machine_id);

CREATE TABLE IF NOT EXISTS default.muxio_wait_queue
(
    machine_id      UInt32,
    ts_s            DateTime(3),
    pid             UInt32,
    tid             UInt32,
    is_epoll        BOOLEAN,
    poll_id         UInt64,
    total_time      UInt64,
    total_requests  UInt64
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'muxio_wait', 'clickhouse_muxio_wait', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.muxio_wait_mv TO default.muxio_wait AS
SELECT * FROM default.muxio_wait_queue;

-- ================ file
CREATE TABLE IF NOT EXISTS default.muxio_file_local
(
    machine_id  UInt32,
    ts_s        DateTime(3),
    poll_id     UInt64,
    fs_magic    UInt32,
    device_id   UInt32,
    inode_id    UInt64,
    mode        UInt8,
    hist0 UInt32, hist1 UInt32, hist2 UInt32, hist3 UInt32,
    hist4 UInt32, hist5 UInt32, hist6 UInt32, hist7 UInt32
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY ts_s;

CREATE TABLE IF NOT EXISTS default.muxio_file AS default.muxio_file_local
ENGINE = Distributed(cluster_3s_1r, default, muxio_file_local, machine_id);

CREATE TABLE IF NOT EXISTS default.muxio_file_queue
(
    machine_id  UInt32,
    ts_s        DateTime(3),
    poll_id     UInt64,
    fs_magic    UInt32,
    device_id   UInt32,
    inode_id    UInt64,
    mode        UInt8,
    hist0 UInt32, hist1 UInt32, hist2 UInt32, hist3 UInt32,
    hist4 UInt32, hist5 UInt32, hist6 UInt32, hist7 UInt32
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'muxio_file', 'clickhouse_muxio_file', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.muxio_file_mv TO default.muxio_file AS
SELECT * FROM default.muxio_file_queue;


-- =============================================================
-- NET (socket)
-- =============================================================

-- ================ socket context
CREATE TABLE IF NOT EXISTS default.socket_context_local
(
    machine_id  UInt32,
    inode_id    UInt64,
    family      UInt16,
    type        UInt16,
    protocol    UInt16
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY inode_id;

CREATE TABLE IF NOT EXISTS default.socket_context AS default.socket_context_local
ENGINE = Distributed(cluster_3s_1r, default, socket_context_local, machine_id);

CREATE TABLE IF NOT EXISTS default.socket_context_queue
(
    machine_id  UInt32,
    inode_id    UInt64,
    family      UInt16,
    type        UInt16,
    protocol    UInt16
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'socket_context', 'clickhouse_socket_context', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.socket_context_mv TO default.socket_context AS
SELECT * FROM default.socket_context_queue;

-- ================ socket inet
CREATE TABLE IF NOT EXISTS default.socket_inet_local
(
    machine_id      UInt32,
    inode_id        UInt64,
    netns_cookie    UInt64,
    src_address     VARCHAR,
    src_port        UInt16,
    dst_address     VARCHAR,
    dst_port        UInt16
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY inode_id;

CREATE TABLE IF NOT EXISTS default.socket_inet AS default.socket_inet_local
ENGINE = Distributed(cluster_3s_1r, default, socket_inet_local, machine_id);

CREATE TABLE IF NOT EXISTS default.socket_inet_queue
(
    machine_id      UInt32,
    inode_id        UInt64,
    netns_cookie    UInt64,
    src_address     VARCHAR,
    src_port        UInt16,
    dst_address     VARCHAR,
    dst_port        UInt16
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'socket_inet', 'clickhouse_socket_inet', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.socket_inet_mv TO default.socket_inet AS
SELECT * FROM default.socket_inet_queue;

-- ================ socket map
CREATE TABLE IF NOT EXISTS default.socket_map_local
(
    machine_id      UInt32,
    sock1_inode_id  UInt64,
    sock2_inode_id  UInt64
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY sock1_inode_id;

CREATE TABLE IF NOT EXISTS default.socket_map AS default.socket_map_local
ENGINE = Distributed(cluster_3s_1r, default, socket_map_local, machine_id);

CREATE TABLE IF NOT EXISTS default.socket_map_queue
(
    machine_id      UInt32,
    sock1_inode_id  UInt64,
    sock2_inode_id  UInt64
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'socket_map', 'clickhouse_socket_map', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.socket_map_mv TO default.socket_map AS
SELECT * FROM default.socket_map_queue;


-- =============================================================
-- PROCESS_CONTEXT
-- =============================================================

-- ================ process context
CREATE TABLE IF NOT EXISTS default.process_context_local
(
    machine_id  UInt32,
    pid         UInt32,
    cgroup      Nullable(VARCHAR),
    argv        VARCHAR,
    exe         Nullable(VARCHAR)
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY pid;

CREATE TABLE IF NOT EXISTS default.process_context AS default.process_context_local
ENGINE = Distributed(cluster_3s_1r, default, process_context_local, machine_id);

CREATE TABLE IF NOT EXISTS default.process_context_queue
(
    machine_id  UInt32,
    pid         UInt32,
    cgroup      Nullable(VARCHAR),
    argv        VARCHAR,
    exe         Nullable(VARCHAR)
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'process_context', 'clickhouse_process_context', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.process_context_mv TO default.process_context AS
SELECT * FROM default.process_context_queue;

-- ================ docker
CREATE TABLE IF NOT EXISTS default.docker_local
(
    machine_id  UInt32,
    cgroup      VARCHAR,
    id          VARCHAR,
    name        Nullable(VARCHAR),
    image_name  Nullable(VARCHAR),
    image_hash  Nullable(VARCHAR)
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY id;

CREATE TABLE IF NOT EXISTS default.docker AS default.docker_local
ENGINE = Distributed(cluster_3s_1r, default, docker_local, machine_id);

CREATE TABLE IF NOT EXISTS default.docker_queue
(
    machine_id  UInt32,
    cgroup      VARCHAR,
    id          VARCHAR,
    name        Nullable(VARCHAR),
    image_name  Nullable(VARCHAR),
    image_hash  Nullable(VARCHAR)
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'docker', 'clickhouse_docker', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.docker_mv TO default.docker AS
SELECT * FROM default.docker_queue;

-- ================ k8s
CREATE TABLE IF NOT EXISTS default.k8s_local
(
    machine_id      UInt32,
    cgroup          VARCHAR,
    id              VARCHAR,
    namespace       Nullable(VARCHAR),
    pod_name        Nullable(VARCHAR),
    container_name  Nullable(VARCHAR),
    image_name      VARCHAR
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY id;

CREATE TABLE IF NOT EXISTS default.k8s AS default.k8s_local
ENGINE = Distributed(cluster_3s_1r, default, k8s_local, machine_id);

CREATE TABLE IF NOT EXISTS default.k8s_queue
(
    machine_id      UInt32,
    cgroup          VARCHAR,
    id              VARCHAR,
    namespace       Nullable(VARCHAR),
    pod_name        Nullable(VARCHAR),
    container_name  Nullable(VARCHAR),
    image_name      VARCHAR
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'k8s', 'clickhouse_k8s', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.k8s_mv TO default.k8s AS
SELECT * FROM default.k8s_queue;


-- =============================================================
-- TASKSTATS
-- =============================================================

-- ================ taskstats
CREATE TABLE IF NOT EXISTS default.taskstats_local
(
    machine_id      UInt32,
    ts              DateTime(3),
    pid             UInt32,
    tid             UInt32,
    comm            VARCHAR,
    nvcsw           UInt64,
    nivcsw          UInt64,
    run_time_total  UInt64,
    rq_time_total   UInt64,
    rq_count        UInt64,
    blkio_time_total        UInt64,
    blkio_count             UInt64,
    uninterruptible_total   UInt64,
    freepages_time_total    UInt64,
    freepages_count         UInt64,
    thrashing_time_total    UInt64,
    thrashing_count         UInt64,
    swapin_time_total       UInt64,
    swapin_count            UInt64
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY ts;

CREATE TABLE IF NOT EXISTS default.taskstats AS default.taskstats_local
ENGINE = Distributed(cluster_3s_1r, default, taskstats_local, machine_id);

CREATE TABLE IF NOT EXISTS default.taskstats_queue
(
    machine_id      UInt32,
    ts              DateTime(3),
    pid             UInt32,
    tid             UInt32,
    comm            VARCHAR,
    nvcsw           UInt64,
    nivcsw          UInt64,
    run_time_total  UInt64,
    rq_time_total   UInt64,
    rq_count        UInt64,
    blkio_time_total        UInt64,
    blkio_count             UInt64,
    uninterruptible_total   UInt64,
    freepages_time_total    UInt64,
    freepages_count         UInt64,
    thrashing_time_total    UInt64,
    thrashing_count         UInt64,
    swapin_time_total       UInt64,
    swapin_count            UInt64
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'taskstats', 'clickhouse_taskstats', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.taskstats_mv TO default.taskstats AS
SELECT * FROM default.taskstats_queue;


-- ================ view
CREATE OR REPLACE VIEW default.taskstats_view AS
SELECT
    machine_id,
    ts,
    time_diff,
    pid,
    tid,
    comm,
    run_time      / time_diff AS run_share,
    rq_time       / time_diff AS rq_share,
    uninterruptible_time / time_diff AS uninterruptible_share,
    blkio_time    / time_diff AS blkio_share,
    greatest((time_diff - (run_time + rq_time + uninterruptible_time)) / time_diff, 0) AS interruptible_share
FROM (
    SELECT
        machine_id,
        ts,
        dateDiff('ns', ts_last, ts) AS time_diff,
        pid,
        tid,
        comm,
        run_time_curr  - run_time_last  AS run_time,
        rq_time_curr   - rq_time_last   AS rq_time,
        uninterruptible_time_curr - uninterruptible_time_last AS uninterruptible_time,
        blkio_time_curr - blkio_time_last AS blkio_time
    FROM (
        SELECT
            machine_id,
            ts,
            lagInFrame(ts) OVER (PARTITION BY machine_id, tid ORDER BY ts) AS ts_last,
            pid,
            tid,
            comm,
            run_time_total AS run_time_curr,
            lagInFrame(run_time_total) OVER (PARTITION BY machine_id, tid ORDER BY ts) AS run_time_last,
            rq_time_total AS rq_time_curr,
            lagInFrame(rq_time_total)  OVER (PARTITION BY machine_id, tid ORDER BY ts) AS rq_time_last,
            uninterruptible_total AS uninterruptible_time_curr,
            lagInFrame(uninterruptible_total) OVER (PARTITION BY machine_id, tid ORDER BY ts) AS uninterruptible_time_last,
            blkio_time_total AS blkio_time_curr,
            lagInFrame(blkio_time_total) OVER (PARTITION BY machine_id, tid ORDER BY ts) AS blkio_time_last
        FROM default.taskstats
    )
)
WHERE time_diff IS NOT NULL;


-- =============================================================
-- VFS
-- =============================================================

-- ================ vfs
CREATE TABLE IF NOT EXISTS default.vfs_local
(
    machine_id  UInt32,
    ts_s        DateTime(3),
    pid         UInt32,
    tid         UInt32,
    fs_magic    UInt32,
    device_id   UInt32,
    inode_id    UInt64,
    op          UInt8,
    total_time  UInt64,
    total_requests UInt32,
    hist0 UInt32, hist1 UInt32, hist2 UInt32, hist3 UInt32,
    hist4 UInt32, hist5 UInt32, hist6 UInt32, hist7 UInt32
) ENGINE = MergeTree
PARTITION BY machine_id
ORDER BY ts_s;

CREATE TABLE IF NOT EXISTS default.vfs AS default.vfs_local
ENGINE = Distributed(cluster_3s_1r, default, vfs_local, machine_id);

CREATE TABLE IF NOT EXISTS default.vfs_queue
(
    machine_id  UInt32,
    ts_s        DateTime(3),
    pid         UInt32,
    tid         UInt32,
    fs_magic    UInt32,
    device_id   UInt32,
    inode_id    UInt64,
    op          UInt8,
    total_time  UInt64,
    total_requests UInt32,
    hist0 UInt32, hist1 UInt32, hist2 UInt32, hist3 UInt32,
    hist4 UInt32, hist5 UInt32, hist6 UInt32, hist7 UInt32
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'vfs', 'clickhouse_vfs', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.vfs_mv TO default.vfs AS
SELECT * FROM default.vfs_queue;


-- =============================================================
-- LINUX_CONSTS
-- =============================================================

CREATE TABLE IF NOT EXISTS default.linux_consts_local
(
    const_type  VARCHAR,
    const_name  VARCHAR,
    `value`     UInt32,
) ENGINE = MergeTree
ORDER BY (const_type, const_name);

CREATE TABLE IF NOT EXISTS default.linux_consts AS default.linux_consts_local
ENGINE = Distributed(cluster_3s_1r, default, linux_consts_local, rand());

CREATE TABLE IF NOT EXISTS default.linux_consts_queue
(
    const_type  VARCHAR,
    const_name  VARCHAR,
    `value`     UInt32,
) ENGINE = Kafka('broker1:9092,broker2:9092,broker3:9092', 'linux_consts', 'clickhouse_linux_consts', 'RowBinary')
SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE MATERIALIZED VIEW default.linux_consts_mv TO default.linux_consts AS
SELECT * FROM default.linux_consts_queue;



