#!/bin/bash
# Copyright [2018] IBM Corp. All Rights Reserved.
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
oc tag docker.io/clouddragons/tradr-node-jquery:1.0 tradr-node-jquery:latest -n openshift
oc tag docker.io/clouddragons/trade-history-python:2.0 trade-history-python:latest  -n openshift
oc tag docker.io/clouddragons/stock-quote-liberty:1.0 stock-quote-liberty:latest  -n openshift
oc tag docker.io/clouddragons/portfolio-spring:1.0.4 portfolio-spring:latest  -n openshift
oc tag docker.io/clouddragons/trader-mq:1.0 trader-mq:latest  -n openshift
oc tag docker.io/clouddragons/event-streams-producer-cp4i:1.0 event-streams-producer-cp4i:latest  -n openshift
oc tag docker.io/clouddragons/event-streams-consumer-cp4i:1.0 event-streams-consumer-cp4i:latest  -n openshift
