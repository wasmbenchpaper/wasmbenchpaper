#!/usr/bin/env bash

#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

### throw error if project_loc is not set ###
if [ -z "$project_loc" ]; then
  echo "project_loc is empty or not set. Please set it to the root path of the benchmark folder."
  exit 1
fi

### throw error if FILE_CLIENT_HOST AND FILE_CLIENT_PASS is not set ###
if [ -z "$FILE_CLIENT_HOST" ]; then
  echo "FILE_CLIENT_HOST is empty or not set. Please set it to the client (username@host) that curls the file server."
  exit 1
fi

if [ -z "$FILE_CLIENT_PASS" ]; then
  echo "FILE_CLIENT_PASS is empty or not set. Please set it to the host's password."
  exit 1
fi

sleep 5
sshpass -p $FILE_CLIENT_PASS ssh $FILE_CLIENT_HOST curl 127.0.0.1:8080 --output m.mp4
sshpass -p $FILE_CLIENT_PASS ssh $FILE_CLIENT_HOST rm m.mp4
bash ./delete_all.sh
sleep 2
