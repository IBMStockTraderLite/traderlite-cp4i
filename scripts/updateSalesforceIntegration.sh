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

# Validate directory  script is run from
if test "$0" = "./updateSalesforceIntegration.sh"
then
   echo "Script being run from correct folder"
else
   echo "Fatal error: Must be run from folder where this script resides"
   exit 1
fi


usage () {
  echo "Usage:"
  echo "updateSalesforceIntegration.sh APPCONNECT_FLOW_URL"
}

# check number of parameters
if [ "$#" -ne 1 ]
then
    usage
    exit 1
fi

# Validate Flow URL
urlregex='(https?)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [[ ! $1 =~ $urlregex ]]; then
   echo "Fatal error: URL to AppConnect Flow is not a well formed URL. Ask your instructor for help"
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
echo "Verifying that Trader Lite is already installed ..."
isTraderLiteInstalled
if [ $? -eq 0 ]; then
   echo "Found Trader Lite installed in this project"
else
   echo "Fatal error: Trader Lite  not installed"
   echo "Install Trader Lite  and try again"
   exit 1
fi

# Patch TraderLite Custom Resource

echo "Updating Trader Lite with new  Salesforce Integration endpoint ..."
oc patch TraderLite/traderlite -p "{\"spec\": {\"salesforceIntegration\": {\"enabled\": true, \"flow\": {\"url\": \"$1\"}}}}" --type=merge

if [ $? -ne 0 ]; then
  echo "Update of Trader Lite failed"
  exit 1
fi

echo "Restarting Portfolio microservice ..."
portfolioPod=`oc  get pods --no-headers -o custom-columns=":metadata.name" --field-selector=status.phase==Running | grep portfolio  | grep -v deploy`
if [ -z "$portfolioPod" ]
then
  echo "Fatal error: no Portfolio pod found. Exiting ..."
  exit 1
fi

echo "Found  Portfolio pod $portfolioPod. Restarting it ..."
oc delete pod  $portfolioPod

echo "Salesforce Integration update completed successfully"
echo "Wait for all pods to be in the 'Ready' state before continuing"
exit 0
