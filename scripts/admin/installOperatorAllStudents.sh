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

# Install Trader Lite operator in all student namespaces

usage () {
  echo "Usage:"
  echo "./installOperatorAllStudents.sh [USERCOUNT]"
  echo "Optional USERCOUNT must be a positive integer greater than 0"
  echo "If USERCOUNT is not provided it defaults to 20"

}

# check  parameters
if [ "$#" -gt 1 ]
then
    usage
    exit 1
fi

# check parameters
if [ "$#" -eq 1 ]
then
    if [ "$1" -eq "$1" ] 2>/dev/null; then
      if [ "$1" -gt 0 ]
      then
        USERCOUNT=$1
      else
        usage
        exit 1
      fi
    else
      usage
      exit 1
    fi
else
    USERCOUNT=20
fi


for i in $(seq $USERCOUNT)
do
  printf -v PROJECT "trader-%03d" $i
  echo "Installing Operator in namespace $PROJECT ..."
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
    echo "Fatal error installing Trader Lite Operator Group in namespace $PROJECT"
    exit 1
  fi


  oc create -f ../../traderlite-operator/deploy/role.yaml -n $PROJECT
  if [ $? -ne 0 ]; then
    echo "Fatal error installing Trader Lite Operator Role in namespace $PROJECT"
    exit 1
  fi


  oc create -f ../../traderlite-operator/deploy/crds/operators.clouddragons.com_traderlites_crd.yaml -n $PROJECT
  if [ $? -ne 0 ]; then
    echo "Fatal error installing Trader Lite Operator CRD in namespace $PROJECT"
    exit 1
  fi

  oc create -f ../../traderlite-operator/deploy/role_binding.yaml -n $PROJECT
  if [ $? -ne 0 ]; then
    echo "Fatal error installing Trader Lite Operator RoleBinding in namespace $PROJECT"
    exit 1
  fi
  oc create -f ../../traderlite-operator/deploy/service_account.yaml -n $PROJECT
  if [ $? -ne 0 ]; then
    echo "Fatal error installing Trader Lite Operator Service Account in namespace $PROJECT"
    exit 1
  fi

  oc create -f ../../traderlite-operator/deploy/olm-catalog/traderlite-operator/manifests/traderlite-operator.clusterserviceversion.yaml -n $PROJECT
  if [ $? -ne 0 ]; then
    echo "Fatal error installing Trader Lite Operator CSV in namespace $PROJECT"
    exit 1
  fi

done
