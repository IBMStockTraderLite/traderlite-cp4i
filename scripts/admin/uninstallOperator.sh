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
  echo "Fatal error accessing cluster via oc command line tool"
  exit 1
fi

echo "Uninstalling operator"
oc delete csv traderlite-operator.v1.0.0
oc delete crd traderlites.operators.clouddragons.com
oc delete sa traderlite-operator
oc delete rolebinding traderlite-operator
oc delete role traderlite-operator
oc delete OperatorGroup $PROJECT-operators
