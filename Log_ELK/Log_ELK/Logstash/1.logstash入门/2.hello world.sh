#!/usr/bin/env sh
# 1.运行命令启动logstash
[root@test1 ~]# /usr/share/logstash/bin/logstash -e 'input{stdin{}}output{stdout{codec=>rubydebug}}'
WARNING: Could not find logstash.yml which is typically located in $LS_HOME/config or /etc/logstash. You can specify the path using --path.settings. Continuing using the defaults
Could not find log4j2 configuration at path /usr/share/logstash/config/log4j2.properties. Using default config which logs errors to the console
[INFO ] 2020-06-10 14:46:39.050 [main] writabledirectory - Creating directory {:setting=>"path.queue", :path=>"/usr/share/logstash/data/queue"}
[INFO ] 2020-06-10 14:46:39.082 [main] writabledirectory - Creating directory {:setting=>"path.dead_letter_queue", :path=>"/usr/share/logstash/data/dead_letter_queue"}
[WARN ] 2020-06-10 14:46:39.663 [LogStash::Runner] multilocal - Ignoring the 'pipelines.yml' file because modules or command line options are specified
[INFO ] 2020-06-10 14:46:39.672 [LogStash::Runner] runner - Starting Logstash {"logstash.version"=>"7.7.1"}
[INFO ] 2020-06-10 14:46:39.714 [LogStash::Runner] agent - No persistent UUID file found. Generating new UUID {:uuid=>"876518eb-a54e-4177-b616-7772c1a3ec7b", :path=>"/usr/share/logstash/data/uuid"}
[INFO ] 2020-06-10 14:46:42.063 [Converge PipelineAction::Create<main>] Reflections - Reflections took 76 ms to scan 1 urls, producing 21 keys and 41 values 
[WARN ] 2020-06-10 14:46:43.866 [[main]-pipeline-manager] LazyDelegatingGauge - A gauge metric of an unknown type (org.jruby.RubyArray) has been created for key: cluster_uuids. This may result in invalid serialization.  It is recommended to log an issue to the responsible developer/development team.
[INFO ] 2020-06-10 14:46:43.872 [[main]-pipeline-manager] javapipeline - Starting pipeline {:pipeline_id=>"main", "pipeline.workers"=>2, "pipeline.batch.size"=>125, "pipeline.batch.delay"=>50, "pipeline.max_inflight"=>250, "pipeline.sources"=>["config string"], :thread=>"#<Thread:0x2af7edc5 run>"}
[INFO ] 2020-06-10 14:46:46.176 [[main]-pipeline-manager] javapipeline - Pipeline started {"pipeline.id"=>"main"}
The stdin plugin is now waiting for input:
[INFO ] 2020-06-10 14:46:46.272 [Agent thread] agent - Pipelines running {:count=>1, :running_pipelines=>[:main], :non_running_pipelines=>[]}
[INFO ] 2020-06-10 14:46:46.609 [Api Webserver] agent - Successfully started Logstash API endpoint {:port=>9600}

# 直接输入"Hello World!",得到返回结果
Hello World!
{
       "message" => "Hello World!",
    "@timestamp" => 2020-06-10T06:49:28.133Z,
          "host" => "test1",
      "@version" => "1"
}

# Ctrl + C 退出
^C[WARN ] 2020-06-10 14:50:37.376 [SIGINT handler] runner - SIGINT received. Shutting down.
[INFO ] 2020-06-10 14:50:37.625 [Converge PipelineAction::Stop<main>] javapipeline - Pipeline terminated {"pipeline.id"=>"main"}
[INFO ] 2020-06-10 14:50:37.702 [LogStash::Runner] runner - Logstash shut down.

