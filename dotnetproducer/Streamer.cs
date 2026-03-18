using Confluent.Kafka;
using Microsoft.Extensions.Hosting;
using System.Reflection;
using System.Runtime.InteropServices;

namespace dotnetproducer
{
    public class Streamer : BackgroundService
    {

        private Generator generator = new Generator();

        private IProducer<string, string> producer;
        private ProducerConfig _producerConfig;

        private Random rnd = new Random(123);

        private string connectionString = Environment.GetEnvironmentVariable("KAFKA_BOOTSTRAP");
        private int uniqueIdentifier = Int32.Parse(Environment.GetEnvironmentVariable("PRODUCER_ID"));
        private PosixSignalRegistration _signalRegistration;

        private bool IsPaused() => !File.Exists("/tmp/producer_running");
        private bool _paused = true;

        public Streamer()
        {
            
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {

            await Task.Delay(8000);
            
            
            _producerConfig = new ProducerConfig
            {
                BootstrapServers = connectionString
            };
            
            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    producer = new ProducerBuilder<string, string>(_producerConfig).Build();
                    break;

                }
                catch (Exception ex)
                {
                    await Task.Delay(2000);
                }
            }

            if (stoppingToken.IsCancellationRequested) throw new Exception("Kafka connection could not be established before cancellation.");
 

            while (!stoppingToken.IsCancellationRequested)  
            {
                bool b = IsPaused();
                if (b != _paused)
                {
                    Console.WriteLine(b ? "Producer paused" : "Producer resumed");
                    _paused = b;
                }

                if (IsPaused())
                {
                    await Task.Delay(500, stoppingToken); // idle while paused
                    continue;
                }

                var (topic, jsonString) = generator.Generate(uniqueIdentifier);

                await producer.ProduceAsync(topic, new Message<string, string>
                {
                    Key = uniqueIdentifier.ToString(),
                    Value = jsonString
                });

                await Task.Delay(rnd.Next(500, 1500), stoppingToken);
            }
        }
        public override async Task StopAsync(CancellationToken cancellationToken)
        {
            producer.Flush(TimeSpan.FromSeconds(5));
            producer.Dispose();

            await base.StopAsync(cancellationToken);
        }
    }
}