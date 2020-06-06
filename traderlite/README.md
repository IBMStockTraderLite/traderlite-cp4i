# IBM Trader Lite V2.0  Helm Chart (Beta Version)

## Introduction

This chart installs the IBM Trader Lite V2.0 microservices.


## Configuration

The following table lists the configurable parameters of this chart and their default values.
The parameters allow you to:
* change the image of any microservice from the one provided by IBM to one that you build (e.g. if you want to try to modify a service)


| Parameter                           | Description                                         | Default                                                                         |
| ----------------------------------- | ----------------------------------------------------| --------------------------------------------------------------------------------|
| | | |
| portfolioMicroservice.service.port | HTTP/S endpoint port |  8080
| portfolioMicroservice.image.repository | image repository |  clouddragons/portfolio-spring-microservices
| portfolioMicroservice.image.tag | image tag | latest
| portfolioMicroservice.image.pullPolicy | image pull policy | Always
| portfolioMicroservice.image.pullSecrets | image pull secret (for protected repository) | `nil`
| | | |
| stockQuoteMicroservice.service.port | HTTP/S endpoint port |  9080
| stockQuoteMicroservice.image.repository | image repository | clouddragons/stock-quote-liberty
| stockQuoteMicroservice.image.tag | image tag | latest
| stockQuoteMicroservice.image.pullPolicy | image pull policy | Always
| stockQuoteMicroservice.image.pullSecrets | image pull secret (for protected repository) | `nil`
| stockQuoteMicroservice.apic.url | APIC  Endpoint |  `nil`
| stockQuoteMicroservice.apic.clientId | APIC ClientId  |  `nil`
| | | |
| tradrMicroservice.service.port | HTTP/S endpoint port |  3000
| tradrMicroservice.image.repository | image repository | clouddragons/tradr-node-jquery-cp4i
| tradrMicroservice.image.tag | image tag | latest
| tradrMicroservice.image.pullPolicy | image pull policy | Always
| tradrMicroservice.image.pullSecrets | image pull secret (for protected repository) | `nil`
| | |
| tradeHistoryMicroservice.service.port | HTTP/S endpoint port |  5000
| tradeHistoryMicroservice.image.repository | image repository | clouddragons/trade-history-python
| tradeHistoryMicroservice.image.tag | image tag | latest
| tradHistoryMicroservice.image.pullPolicy | image pull policy | Always
| tradeHistoryMicroservice.image.pullSecrets | image pull secret (for protected repository) | `nil`
| |
| tradeHistory.image.repository | image repository | clouddragons/trade-history-python
| tradeHistory.image.tag | image tag | latest
| tradHistory.image.pullPolicy | image pull policy | Always
| tradeHistory.image.pullSecrets | image pull secret (for protected repository) | `nil`
| |
| kafkaConnect.image.repository | Kafka Connect subchart image repository | clouddragons/stocktrader-kafka-connect-standalone-cp4i
| kafkaConnect.image.tag | Kafka Connect subchart image tag | latest
| kafkaConnect.image.pullPolicy | Kafka Connect subchart image pull policy | Always
| kafkaConnect.image.pullSecrets | image pull secret (for protected repository) | `nil`
| kafkaConnect.keystore.secret.name | Secret with Kafka topic Java keystore (value key is filename, data is file contents) | kafkaconnect-keystore
| |
| localMQ.license | MQ subchart license | accept
| localMQ.image.repository | MQ subchart image repository | clouddragons/trader-mq
| localMQ.image.tag | MQ subchart image tag | 9.1.5.0-r1
| localMQ.persistence.enabled | MQ subchart persistence | disabled
| localMQ.metrics.enabled | MQ subchart metrics| disabled
| localMQ.queueManager.name | MQ subchart QMgr name | QMTRADER
| localMQ.queueManager.dev.secret.name | MQ subchart password secret | traderlite-localmq-secret
| localMQ.queueManager.dev.secret.adminPasswordKey | MQ subchart admin password key | password
| localMQ.queueManager.dev.secret.appPasswordKey | MQ subchart admin password key | password
| |
| tradeHistoryDB.mongodbDatabase | Mongo subchart db name | trader
| tradeHistoryDB.mongodbUsername| Mongo subchart db user | traderuser
| tradeHistoryDB.mongodbPassword | Mongo subchart db password | n0tSecure
| tradeHistoryDB.nameOverride | Mongo subchart chart name override | mongodb
| tradeHistoryDB.persistence.enabled | Mongo subchart persistence | disabled
| tradeHistoryDB.securityContext.fsGroup | Mongo subchart FS Group | `nil`
| tradeHistoryDB.securityContext.runAsUser | Mongo subchart RunAsUser | `nil`
| tradeHistoryDB.service.port | Mongo subchart Endpoint port | 27017
| |
| tradeTransactionalDB.nameOverride | MariaDB subchart chart name override | mariadb
| tradeTransactionalDB.db.name | MariaDB subchart db name | trader
| tradeTransactionalDB.db.user | MariaDB subchart db user | traderuser
| tradeTransactionalDB.db.password | MariaDB subchart db password | n0tSecure
| tradeTransactionalDB.db.forcePassword | Generate password if not provided | false
| tradeTransactionalDB.rootUser.forcePassword | Generate root password if not provided | false
| tradeTransactionalDB.service.port | MariaDB subchart Endpoint port | 3306
| tradeTransactionalDB.serviceAccount.create | MariaDB create ServiceAccount | false
| tradeTransactionalDB.rbac.create | MariaDB rbac access | false
| tradeTransactionalDB.replication.enabled | MariaDB replication | false
| tradeTransactionalDB.initdbScriptsConfigMap | MariaDB init script ConfigMap | mariadb-init-scripts
| tradeTransactionalDB.securityContext.fsGroup | MariaDB subchart FS Group | `nil`
| tradeTransactionalDB.securityContext.runAsUser | MariaDB subchart RunAsUser | `nil`
| |
| global.kafkaAccess.apiKey | Kafka topic api key | `nil`
| global.kafkaAccess.topic | Kafka topic | `nil`
| global.kafkaAccess.bootstrapHost | Kafka bootstrap host | `nil`
| global.mqaccess.qname | Local MQ queue name | TRADER.EVENT.QUEUE
| global.mqaccess.qmgr| Local MQ Queue Manager | QMTRADER
| global.mqaccess.channel | Local MQ Channel | DEV.APP.SVRCONN
| global.mqaccess.user | Local MQ username | app
| global.mqaccess.password | Local MQ password | passw0rd
| global.mqaccess.secret.name | Local MQ secret with MQ password | traderlite-localmq-secret


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.


## Installing the Chart

You can install the chart by setting the current directory to the folder where this chart is located and running the following command:

```console
helm install traderlite --set key=value[,key=value] --namespace traderlite .
```

This sets the Helm release name to `traderlite` and creates all Kubernetes resources in a namespace called `traderlite`.

## Uninstalling the Chart

```console
$ helm uninstall traderlite
```
