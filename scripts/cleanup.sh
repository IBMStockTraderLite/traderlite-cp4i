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
if test "$0" = "./cleanup.sh"
then
   echo "Script being run from correct folder"
else
   echo "Fatal error: Must be run from folder where this script resides"
   exit 1
fi

usage () {
  echo "Usage: use optional --all flag to delete operator  too"
  echo "cleanup.sh [--all]"
}

if [ "$#" -gt 1 ]
then
    usage
    exit 1
fi

if [ "$#" -eq 1 ]
then
   if [ "$1" != "--all" ]
   then
      usage
      exit 1
   fi
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


oc get TraderLite/traderlite > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Uninstalling  Trader Lite app components"
  oc delete TraderLite/traderlite
  if [ $? -ne 0 ]; then
     echo "Error uninstalling Trader Lite  app components"
     exit 1
  fi
fi


oc get secret kafkaconnect-keystore > /dev/null 2>&1
if [ $? -eq 0 ]; then
  oc delete secret kafkaconnect-keystore
fi


if [ "$#" -eq 1 ]
then
   echo "Uninstalling operator"
   oc delete csv traderlite-operator.v1.0.0
   oc delete crd traderlites.operators.clouddragons.com
   oc delete sa traderlite-operator
   oc delete rolebinding traderlite-operator
   oc delete role traderlite-operator
   oc delete OperatorGroup $PROJECT-operators
fi
