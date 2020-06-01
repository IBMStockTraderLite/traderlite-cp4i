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
if test "$0" = "./cleanup.sh"
then
   echo "Script being run from correct folder"
else
   echo "Fatal error: Must be run from folder where this script resides"
   exit 1
fi

# Delete template objects
echo "Deleting trader lite  app components"
helm uninstall traderlite
if [ $? -ne 0 ]; then
  echo "Error deleting trader lite app components"
  exit 1
else
  echo "trader lite app components successfully deleted"
  exit 0
fi
