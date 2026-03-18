
using System.Text.Json;


namespace dotnetproducer
{
    public class Generator
    {
        private static Random rnd = new Random();
        private string[] topics = new string[21]{"muxio_wait", "iowait", "futex_wait", "futex_wait_staging", "futex_wake", "tcp_discovery", "aio_getevents", "aio_staging", "aio_submit", "aio_file", "linux_consts", "vfs", "vfs_staging", "taskstats", "docker", "k8s", "socket_context", "socket_inet", "socket_map", "muxio_file", "muxio_staging"};
        private Func<int, string>[] generators = new Func<int, string>[21]{muxio_wait, iowait, futex_wait, futex_wait_staging, futex_wake, tcp_discovery, aio_getevents, aio_staging, aio_submit, aio_file, linux_consts, vfs, vfs_staging, taskstats, docker, k8s, socket_context, socket_inet, socket_map, muxio_file, muxio_staging};





        public Generator() {}


        public (string, string) Generate(int prod_id)
        {
            int index = rnd.Next(0, 21);
            Func<int, string> func = generators[index];
            string jsonString = func(prod_id);
            string topic = topics[index];

            return (topic, jsonString);
        }


        // Functions which generate json strings for specific tables in the database
        private static string aio_getevents(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                ts_s = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                pid = rnd.Next(1, 9999),
                tid = rnd.Next(1, 9999),
                aioctx = (ulong)rnd.NextInt64(),
                total_time = (ulong)rnd.NextInt64(0, 100000),
                total_requests = (ulong)rnd.NextInt64(0, 10000)
            };
            return JsonSerializer.Serialize(evt);
        }

        private static string aio_staging(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                ts_s = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                pid = rnd.Next(1, 9999),
                tid = rnd.Next(1, 9999),
                aioctx = (ulong)rnd.NextInt64(),
                additional_time = (ulong)rnd.NextInt64(0, 100000)
            };
            return JsonSerializer.Serialize(evt);
        }  

        private static string aio_submit(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                ts_s = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                pid = rnd.Next(1, 9999),
                tid = rnd.Next(1, 9999),
                aioctx = (ulong)rnd.NextInt64(),
                total_requests = (ulong)rnd.NextInt64(0, 10000)
            };
            return JsonSerializer.Serialize(evt);
        }

        private static string aio_file(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                ts_s = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                aioctx = (ulong)rnd.NextInt64(),
                isreg = (byte)rnd.Next(0, 2),
                fs_magic = rnd.Next(),
                device_id = rnd.Next(),
                inode_id = (ulong)rnd.NextInt64(),
                part0 = (ulong)rnd.NextInt64(),
                bdev = (ulong)rnd.NextInt64(),
                mode = (byte)rnd.Next(0, 255),
                hist0 = rnd.Next(0, 1000),
                hist1 = rnd.Next(0, 1000),
                hist2 = rnd.Next(0, 1000),
                hist3 = rnd.Next(0, 1000),
                hist4 = rnd.Next(0, 1000),
                hist5 = rnd.Next(0, 1000),
                hist6 = rnd.Next(0, 1000),
                hist7 = rnd.Next(0, 1000)
            };
            return JsonSerializer.Serialize(evt);
        }


        private static string tcp_discovery(int prod_id)
        {
            var evt = new
            {
                local_machine_id = prod_id,
                local_inode_id = (ulong)rnd.NextInt64(),
                remote_machine_id = rnd.Next(1, 5),
                remote_inode_id = (ulong)rnd.NextInt64(),
                inserted_at = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
            };
            return JsonSerializer.Serialize(evt);
        }


        private static string futex_wait(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                ts_s = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                pid = rnd.Next(1, 9999),
                tid = rnd.Next(1, 9999),
                futex_key_addr = (ulong)rnd.NextInt64(),
                futex_key_word = (ulong)rnd.NextInt64(),
                futex_key_offset = rnd.Next(),
                total_requests = (ulong)rnd.NextInt64(0, 10000),
                total_time = (ulong)rnd.NextInt64(0, 100000),
                hist0 = rnd.Next(0, 1000),
                hist1 = rnd.Next(0, 1000),
                hist2 = rnd.Next(0, 1000),
                hist3 = rnd.Next(0, 1000),
                hist4 = rnd.Next(0, 1000),
                hist5 = rnd.Next(0, 1000),
                hist6 = rnd.Next(0, 1000),
                hist7 = rnd.Next(0, 1000)
            };
            return JsonSerializer.Serialize(evt);
        }

        private static string futex_wait_staging(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                ts_s = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                pid = rnd.Next(1, 9999),
                tid = rnd.Next(1, 9999),
                futex_key_addr = (ulong)rnd.NextInt64(),
                futex_key_word = (ulong)rnd.NextInt64(),
                futex_key_offset = rnd.Next(),
                additional_time = (ulong)rnd.NextInt64(0, 100000)
            };
            return JsonSerializer.Serialize(evt);
        }

        private static string futex_wake(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                ts_s = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                pid = rnd.Next(1, 9999),
                tid = rnd.Next(1, 9999),
                futex_key_addr = (ulong)rnd.NextInt64(),
                futex_key_word = (ulong)rnd.NextInt64(),
                futex_key_offset = rnd.Next(),
                total_requests = (ulong)rnd.NextInt64(0, 10000),
                successful_count = (ulong)rnd.NextInt64(0, 10000)
            };
            return JsonSerializer.Serialize(evt);
        }


        private static string iowait(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                ts_s = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                pid = rnd.Next(1, 9999),
                tid = rnd.Next(1, 9999),
                part0 = (ulong)rnd.NextInt64(),
                bdev = (ulong)rnd.NextInt64(),
                total_time = (ulong)rnd.NextInt64(0, 100000),
                sector_cnt = rnd.Next(0, 10000),
                total_requests = rnd.Next(0, 10000),
                hist0 = rnd.Next(0, 1000),
                hist1 = rnd.Next(0, 1000),
                hist2 = rnd.Next(0, 1000),
                hist3 = rnd.Next(0, 1000),
                hist4 = rnd.Next(0, 1000),
                hist5 = rnd.Next(0, 1000),
                hist6 = rnd.Next(0, 1000),
                hist7 = rnd.Next(0, 1000)
            };
            return JsonSerializer.Serialize(evt);
        }


        private static string muxio_wait(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                ts_s = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                pid = rnd.Next(1, 9999),
                tid = rnd.Next(1, 9999),
                is_epoll = rnd.Next(0, 2) == 1,
                poll_id = rnd.Next(1, 10000),
                total_time = rnd.Next(0, 9999),
                total_requests = rnd.Next(0, 9999)
            };
            return JsonSerializer.Serialize(evt);
        }

        private static string muxio_staging(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                ts_s = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                pid = rnd.Next(1, 9999),
                tid = rnd.Next(1, 9999),
                is_epoll = rnd.Next(0, 2) == 1,
                poll_id = rnd.Next(1, 10000),
                additional_time = rnd.Next(0, 9999),
            };
            return JsonSerializer.Serialize(evt);
        }

        private static string muxio_file(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                ts_s = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                is_epoll = rnd.Next(0, 2) == 1,
                poll_id = (ulong)rnd.NextInt64(),
                fs_magic = rnd.Next(),
                device_id = rnd.Next(),
                inode_id = (ulong)rnd.NextInt64(),
                total_time = (ulong)rnd.NextInt64(0, 100000),
                count = (ulong)rnd.NextInt64(0, 10000)
            };
            return JsonSerializer.Serialize(evt);
        }


        private static string socket_context(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                inode_id = (ulong)rnd.NextInt64(),
                family = (ushort)rnd.Next(0, 10),
                type = (ushort)rnd.Next(0, 5),
                protocol = (ushort)rnd.Next(0, 255)
            };
            return JsonSerializer.Serialize(evt);
        }

        private static string socket_inet(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                inode_id = (ulong)rnd.NextInt64(),
                netns_cookie = (ulong)rnd.NextInt64(),
                src_address = "192.168.1." + rnd.Next(1, 255),
                src_port = (ushort)rnd.Next(1024, 65535),
                dst_address = "10.0.0." + rnd.Next(1, 255),
                dst_port = (ushort)rnd.Next(1024, 65535)
            };
            return JsonSerializer.Serialize(evt);
        }

        private static string socket_map(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                sock1_inode_id = (ulong)rnd.NextInt64(),
                sock2_inode_id = (ulong)rnd.NextInt64()
            };
            return JsonSerializer.Serialize(evt);
        }
        

        private static string docker(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                cgroup = "/docker/" + Guid.NewGuid(),
                id = Guid.NewGuid().ToString("N"),
                name = "container_" + rnd.Next(1, 100),
                image_name = "nginx",
                image_hash = Guid.NewGuid().ToString("N")
            };
            return JsonSerializer.Serialize(evt);
        }

        private static string k8s(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                cgroup = "cgroup",
                id = $"{rnd.Next(1, 20)}",
                @namespace = "default",
                pod_name = "podName",
                container_name = "containerName",
                image_name = "imageName"
            };
            return JsonSerializer.Serialize(evt);
        }


        private static string taskstats(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                ts = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                pid = rnd.Next(1, 9999),
                tid = rnd.Next(1, 9999),
                comm = "process_" + rnd.Next(1, 100),
                nvcsw = (ulong)rnd.NextInt64(0, 10000),
                nivcsw = (ulong)rnd.NextInt64(0, 10000),
                run_time_total = (ulong)rnd.NextInt64(0, 100000),
                rq_time_total = (ulong)rnd.NextInt64(0, 100000),
                rq_count = (ulong)rnd.NextInt64(0, 10000),
                blkio_time_total = (ulong)rnd.NextInt64(0, 100000),
                blkio_count = (ulong)rnd.NextInt64(0, 10000),
                uninterruptible_total = (ulong)rnd.NextInt64(0, 100000),
                freepages_time_total = (ulong)rnd.NextInt64(0, 100000),
                freepages_count = (ulong)rnd.NextInt64(0, 10000),
                thrashing_time_total = (ulong)rnd.NextInt64(0, 100000),
                thrashing_count = (ulong)rnd.NextInt64(0, 10000),
                swapin_time_total = (ulong)rnd.NextInt64(0, 100000),
                swapin_count = (ulong)rnd.NextInt64(0, 10000)
            };
            return JsonSerializer.Serialize(evt);
        }


        private static string vfs(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                ts_s = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                pid = rnd.Next(1, 9999),
                tid = rnd.Next(1, 9999),
                fs_magic = rnd.Next(),
                device_id = rnd.Next(),
                inode_id = (ulong)rnd.NextInt64(),
                op = (byte)rnd.Next(0, 10),
                total_time = (ulong)rnd.NextInt64(0, 100000),
                total_requests = rnd.Next(0, 10000),
                hist0 = rnd.Next(0, 1000),
                hist1 = rnd.Next(0, 1000),
                hist2 = rnd.Next(0, 1000),
                hist3 = rnd.Next(0, 1000),
                hist4 = rnd.Next(0, 1000),
                hist5 = rnd.Next(0, 1000),
                hist6 = rnd.Next(0, 1000),
                hist7 = rnd.Next(0, 1000)
            };
            return JsonSerializer.Serialize(evt);
        }

        private static string vfs_staging(int prod_id)
        {
            var evt = new
            {
                machine_id = prod_id,
                ts_s = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                pid = rnd.Next(1, 9999),
                tid = rnd.Next(1, 9999),
                fs_magic = rnd.Next(),
                device_id = rnd.Next(),
                inode_id = (ulong)rnd.NextInt64(),
                op = (byte)rnd.Next(0, 10),
                additional_time = (ulong)rnd.NextInt64(0, 100000)
            };
            return JsonSerializer.Serialize(evt);
        }
        

        private static string linux_consts(int prod_id)
        {
            var evt = new
            {
                const_type = "constType",
                const_name = "constName",
                value = rnd.Next(0, 10000)
            };
            return JsonSerializer.Serialize(evt);
        }

        
    }
}
