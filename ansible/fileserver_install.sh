#!/bin/bash

docker run -p 31080:8908 \
-d --name file-service-old \
-e JVM_Xms=2048m -e JVM_Xmx=2048m \
-e JVM_MaxNewSize=256m -e JVM_MaxMetaspaceSize=256m \
-e JAR_Name=file-service-1.0.0.jar -e TZ=Asia/Shanghai \
-e max_file_size=5MB -e max_request_size=5MB \
-e log_stash=202.9.34.150:9600 -e vox_path=/home/listen/Apps/voice/vox/ \
-e tts_path=/home/listen/Apps/voice/tts/ -e recording_path=/ \
-e file_path=/home/listen/Apps/voice/file/ \
-e greeting_path=/home/listen/Apps/voice/greeting/ \
-e webchat_path=/home/listen/Apps/logs \
-v /logs:/home/listen/Apps/logs \
-v /data/vox-1.3.0:/home/listen/Apps/voice \
-v /mnt/recordings/recording1:/mnt/volumes/recordings \
-v /mnt/recordings/recording2:/mnt/volumes/recording-new \
-v /mnt/recordings/recording3:/mnt/volumes/recording3 registry:5000/wecloud/file-service:master-23
