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
if test "$0" = "./addKafkaIntegration.sh"
then
   echo "Script being run from correct folder"
else
   echo "Fatal error: Must be run from folder where this script resides"
   exit 1
fi

usage () {
  echo "Usage:"
  echo "addKafkaIntegration.sh KAFKA_BOOTSTRAP_SERVER  KAFKA_API_KEY JAVA_KEYSTORE_FILE"
}

# consumerRecordst number of parameters
if [ "$#" -ne 3 ]
then
    usage
    exit 1
fi

# Validate bootstrap host+port
bootstrapregex='(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9]):[0-9]+'
if [[ ! $1 =~ $bootstrapregex ]]; then
   echo "Fatal error: Bootstrap hostname+port is not well formed. Ask your instructor for help"
   exit 1
fi

# Java keystore file must exist
if [ ! -f "$3" ]; then
   echo "Fatal error: Java keystore file required"
   usage
   exit 1
fi


# Validate STUDENTID
if [ -z "$STUDENTID" ]; then
   echo "Fatal error: required env variable STUDENTID not set"
   echo "Run the command:"
   echo "export STUDENTID=usernnn"
   echo "where usernnn is your assigned student id"
   echo "and rerun the script"
   exit 1
fi

echo "Validating student id  ..."
sidregex='^user0[0-4][1-9]$|^user0[1-5]0$'
if [[ ! $STUDENTID =~ $sidregex ]]
then
   echo "Fatal error: $STUDENTID is not a valid student id. Ask your instructor for help"
   exit 1
fi

# Validate oc setup and project folder
PROJECT=`oc project -q`
if [ $? -ne 0 ]; then
  echo "Fatal error running OpenShift CLI command 'oc project'"
  echo "Make sure your oc CLI is configured for your OpenShift cluster"
  exit 1
fi

if [[ "$PROJECT" != "trader-$STUDENTID" ]]; then
   echo "Fatal error: you must be in the trader-$STUDENTID project"
   echo "Run the command:"
   echo  "   oc project trader-$STUDENTID"
   echo "and rerun the script"
   exit 1
fi

# Passed validation - do initial install
source ./helpers/utils.sh

# Checking if Trader Lite V2.0 chart already installed
echo "Verifying that the Trader Lite Helm chart is already installed ..."
isTraderLiteInstalled
if [ $? -eq 0 ]; then
   echo "Found the Trader Lite Helm chart installed in this project"
else
   echo "Fatal error: Trader Lite Helm chart not installed"
   echo "Install the Trader Lite Helm chart and try again"
   exit 1
fi


# Kafka now being used
KAFKA_TOPIC=stocktrader-$STUDENTID
echo "Using $KAFKA_TOPIC as Kafka topic name ..."

# Reinstalling Stock Trader Helm chart

KEYSTORE_SECRET_NAME=`helm get values traderlite --all | yq -r .kafkaConnect.keystore.secret.name`
echo "Adding secret $KEYSTORE_SECRET_NAME with downloaded Java keystore"
oc create secret generic $KEYSTORE_SECRET_NAME --from-file=es-cert.jks=$3
if [ $? -ne 0 ]; then
  echo "Update of Kafka access secret failed"
  exit 1
fi

echo "Upgrading Trader Lite Helm chart with Kafka Integration enabled ..."
helm upgrade traderlite --set kafkaIntegration.enabled=true --set global.kafkaAccess.apiKey=$2 --set global.kafkaAccess.topic=$KAFKA_TOPIC --set global.kafkaAccess.bootstrapHost=$1  --reuse-values ../traderlite
if [ $? -ne 0 ]; then
  echo "Upgrade of Trader Lite Helm chart failed"
  exit 1
fi

echo "Kafka Integration configured successfully"
echo "Wait for all pods to be in the 'Ready' state before continuing"
exit 0
