#!/bin/bash
# Copyright [2018-2020] IBM Corp. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

# Validate directory  script is run form
if test "$0" = "./get-eventstreams-certs.sh"
then
   echo "Script being run from correct folder"
else
   echo "Fatal error: Must be run from folder where this script resides"
   exit 1
fi


usage () {
  echo "Usage:"
  echo "get-eventstreams-certs.sh EVENTSTREAMS_BROKER_HOST EVENTSTREAMS_BROKER_PORT"
}

# consumerRecordst number of parameters
if [ "$#" -ne 2 ]
then
    usage
    exit 1
fi

# Validate bootstrap host+port
bootstrapregex='(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9]):[0-9]+'
if [[ ! $1:$2 =~ $bootstrapregex ]]; then
   echo "Fatal error: Bootstrap hostname+port is not well formed. Ask your instructor for help"
   exit 1
fi

# Validate host+port listening
nc -zv $1 $2 >/dev/null
if [ $? -ne 0 ]; then
   echo "Fatal error: Cannot reach bootstrap host+port"
   exit 1
fi

# Import bootstrap cert to build into Kafka connect image
openssl s_client -showcerts -connect es4workshop-ibm-es-proxy-route-bootstrap-eventstreams.icp4i-workshop-f0093114134cf555e1a213f3756140db-0000.us-east.containers.appdomain.cloud:443 </dev/null 2>/dev/null|openssl x509 -outform PEM >../../kafkaconnect/eventstreams-bootstrap.pem
if [ $? -ne 0 ]; then
   echo "Fatal error: Cannot import EventStreams bootstrap certs"
   exit 1
else
   echo "Sucessfully imported EvenStreams bootstrap certs"
   exit 0
fi
