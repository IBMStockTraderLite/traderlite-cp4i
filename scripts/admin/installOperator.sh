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


#

PROJECT=`oc project -q`
if [ $? -ne 0 ]; then
  echo "Fatal error accessing cluster via oc comannd line tool"
  exit 1
fi

echo "Installing Trader Lite Operator in namespace $PROJECT ..."
echo ""
echo "Installing Trader Lite Operator Group ..."
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


echo "Installing Trader Lite Operator CRD ..."
oc create -f ../../traderlite-operator/deploy/crds/operators.clouddragons.com_traderlites_crd.yaml -n $PROJECT
if [ $? -ne 0 ]; then
  echo "Fatal error installing Trader Lite Operator CRD in namespace $PROJECT"
  exit 1
fi

echo "Installing Trader Lite Operator Role ..."
oc create -f ../../traderlite-operator/deploy/role.yaml -n $PROJECT
if [ $? -ne 0 ]; then
  echo "Fatal error installing Trader Lite Operator Role in namespace $PROJECT"
  exit 1
fi

echo "Installing Trader Lite Operator RoleBinding ..."
oc create -f ../../traderlite-operator/deploy/role_binding.yaml -n $PROJECT
if [ $? -ne 0 ]; then
  echo "Fatal error installing Trader Lite Operator RoleBinding in namespace $PROJECT"
  exit 1
fi

echo "Installing Trader Lite Operator Service Account ..."
oc create -f ../../traderlite-operator/deploy/service_account.yaml -n $PROJECT
if [ $? -ne 0 ]; then
  echo "Fatal error installing Trader Lite Operator Service Account in namespace $PROJECT"
  exit 1
fi

#echo "Installing Trader Lite Operator CSV ..."
oc create -f ../../traderlite-operator/deploy/olm-catalog/traderlite-operator/manifests/traderlite-operator.clusterserviceversion.yaml -n $PROJECT
if [ $? -ne 0 ]; then
  echo "Fatal error installing Trader Lite Operator CSV in namespace $PROJECT"
  exit 1
fi

echo "Trader Lite Operator successfully installed"
