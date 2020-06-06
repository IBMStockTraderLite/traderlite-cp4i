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
if test "$0" = "./installOperator.sh"
then
   echo "Script being run from correct folder"
else
   echo "Fatal error: Must be run from folder where this script resides"
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


echo "Installing Operator ..."
cat <<EOF | oc create -f -
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: $PROJECT-operators
spec:
  targetNamespaces:
  - $PROJECT
EOF

if [ $? -ne 0 ]; then
  echo "Fatal error installing Trader Lite Operator Group"
  exit 1
fi

oc create -f ../traderlite-operator/deploy/role.yaml
if [ $? -ne 0 ]; then
  echo "Fatal error installing Trader Lite Operator Role"
  exit 1
fi
oc create -f ../traderlite-operator/deploy/role_binding.yaml
if [ $? -ne 0 ]; then
  echo "Fatal error installing Trader Lite Operator RoleBinding"
  exit 1
fi
oc create -f ../traderlite-operator/deploy/service_account.yaml
if [ $? -ne 0 ]; then
  echo "Fatal error installing Trader Lite Operator Service Account "
  exit 1
fi
oc create -f ../traderlite-operator/deploy/crds/operators.clouddragons.com_traderlites_crd.yaml
if [ $? -ne 0 ]; then
  echo "Fatal error installing Trader Lite Operator CRD"
  exit 1
fi

oc create -f ../traderlite-operator/deploy/olm-catalog/traderlite-operator/manifests/traderlite-operator.clusterserviceversion.yaml
if [ $? -ne 0 ]; then
  echo "Fatal error installing Trader Lite Operator CSV"
  exit 1
fi

echo "Trader Lite Operator install successful"
exit 0
