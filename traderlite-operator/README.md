# IBM Trader Lite V2.0  Operator (Beta Version)

## Introduction

This operator installs the IBM Trader Lite V2.0 microservices application  via a Custom Resource called `TraderLite`.

## Configuration

The following table lists the configurable parameters of the Custom Resource, their default values and whether or not a value must be provided for each parameter in order to create a new instance.

The parameters must be included under the **spec:** label in the Custom Resource. For example:
```
apiVersion: operators.clouddragons.com/v1
kind: TraderLite
metadata:
  name: traderlite
spec:
  stockQuoteMicroservice:
    apic:
      clientId: 23tyU...
      url: https://....

  ...

```


| Parameter                           | Description                                         | Default                                                                         | Required ?
| ----------------------------------- | ----------------------------------------------------| ------------------------------------------------------------------| ---------------------|
| | | |
| stockQuoteMicroservice.apic.url | APIC  Endpoint for Stock Quote service |  `nil` |  Yes
| stockQuoteMicroservice.apic.clientId | APIC ClientId for Stock Quote service |  `nil` | Yes
| stockQuoteMicroservice.service.port | HTTP/S endpoint port |  9080 | No
| stockQuoteMicroservice.image.repository | image repository | clouddragons/stock-quote-liberty | No
| stockQuoteMicroservice.image.tag | image tag | latest | No
| stockQuoteMicroservice.image.pullPolicy | image pull policy | Always | No
| stockQuoteMicroservice.image.pullSecrets | image pull secret (for protected repository) | `nil` | No
| | | |
| portfolioMicroservice.service.port | HTTP/S endpoint port |  8080 | No
| portfolioMicroservice.image.repository | image repository |  clouddragons/portfolio-spring-microservices | No
| portfolioMicroservice.image.tag | image tag | latest | No
| portfolioMicroservice.image.pullPolicy | image pull policy | Always | No
| portfolioMicroservice.image.pullSecrets | image pull secret (for protected repository) | `nil` | No
| | | |
| tradrMicroservice.service.port | HTTP/S endpoint port |  3000 | No
| tradrMicroservice.image.repository | image repository | clouddragons/tradr-node-jquery-cp4i | No
| tradrMicroservice.image.tag | image tag | latest | No
| tradrMicroservice.image.pullPolicy | image pull policy | Always | No
| tradrMicroservice.image.pullSecrets | image pull secret (for protected repository) | `nil` | No
| | |
| tradeHistoryMicroservice.service.port | HTTP/S endpoint port |  5000 | No
| tradeHistoryMicroservice.image.repository | image repository | clouddragons/trade-history-python | No
| tradeHistoryMicroservice.image.tag | image tag | latest | No
| tradHistoryMicroservice.image.pullPolicy | image pull policy | Always | No
| tradeHistoryMicroservice.image.pullSecrets | image pull secret (for protected repository) | `nil` | No
| |
| tradeHistory.image.repository | image repository | clouddragons/trade-history-python | No
| tradeHistory.image.tag | image tag | latest | No
| tradHistory.image.pullPolicy | image pull policy | Always | No
| tradeHistory.image.pullSecrets | image pull secret (for protected repository) | `nil` | No
| |
| kafkaConnect.image.repository | Kafka Connect subchart image repository | clouddragons/stocktrader-kafka-connect-standalone-cp4i | No
| kafkaConnect.image.tag | Kafka Connect subchart image tag | latest | No
| kafkaConnect.image.pullPolicy | Kafka Connect subchart image pull policy | Always | No
| kafkaConnect.image.pullSecrets | image pull secret (for protected repository) | `nil` | No
| kafkaConnect.keystore.secret.name | Secret with Kafka topic Java keystore (value key is filename, data is file contents) | kafkaconnect-keystore | No
| |
| localMQ.license | MQ subchart license | accept | No
| localMQ.image.repository | MQ subchart image repository | clouddragons/trader-mq | No
| localMQ.image.tag | MQ subchart image tag | 9.1.5.0-r1 | No
| localMQ.persistence.enabled | MQ subchart persistence | disabled | No
| localMQ.metrics.enabled | MQ subchart metrics| disabled | No
| localMQ.queueManager.name | MQ subchart QMgr name | QMTRADER | No
| localMQ.queueManager.dev.secret.name | MQ subchart password secret | traderlite-localmq-secret | No
| localMQ.queueManager.dev.secret.adminPasswordKey | MQ subchart admin password key | password | No
| localMQ.queueManager.dev.secret.appPasswordKey | MQ subchart admin password key | password | No
| |
| tradeHistoryDB.mongodbDatabase | Mongo subchart db name | trader | No
| tradeHistoryDB.mongodbUsername| Mongo subchart db user | traderuser | No
| tradeHistoryDB.mongodbPassword | Mongo subchart db password | n0tSecure | No
| tradeHistoryDB.nameOverride | Mongo subchart chart name override | mongodb | No
| tradeHistoryDB.persistence.enabled | Mongo subchart persistence | disabled | No
| tradeHistoryDB.securityContext.fsGroup | Mongo subchart FS Group | `nil` | No
| tradeHistoryDB.securityContext.runAsUser | Mongo subchart RunAsUser | `nil` | No
| tradeHistoryDB.service.port | Mongo subchart Endpoint port | 27017 | No
| |
| tradeTransactionalDB.nameOverride | MariaDB subchart chart name override | mariadb | No
| tradeTransactionalDB.db.name | MariaDB subchart db name | trader | No
| tradeTransactionalDB.db.user | MariaDB subchart db user | traderuser | No
| tradeTransactionalDB.db.password | MariaDB subchart db password | n0tSecure | No
| tradeTransactionalDB.db.forcePassword | Generate password if not provided | false | No
| tradeTransactionalDB.rootUser.forcePassword | Generate root password if not provided | false | No
| tradeTransactionalDB.service.port | MariaDB subchart Endpoint port | 3306 | No
| tradeTransactionalDB.serviceAccount.create | MariaDB create ServiceAccount | false | No
| tradeTransactionalDB.rbac.create | MariaDB rbac access | false | No
| tradeTransactionalDB.replication.enabled | MariaDB replication | false | No
| tradeTransactionalDB.initdbScriptsConfigMap | MariaDB init script ConfigMap | mariadb-init-scripts | No
| tradeTransactionalDB.securityContext.fsGroup | MariaDB subchart FS Group | `nil` | No
| tradeTransactionalDB.securityContext.runAsUser | MariaDB subchart RunAsUser | `nil` | No
| |
| global.kafkaAccess.apiKey | Kafka topic api key | `nil` | No
| global.kafkaAccess.topic | Kafka topic | `nil` | No
| global.kafkaAccess.bootstrapHost | Kafka bootstrap host | `nil` | No
| global.mqaccess.qname | Local MQ queue name | TRADER.EVENT.QUEUE | No
| global.mqaccess.qmgr| Local MQ Queue Manager | QMTRADER | No
| global.mqaccess.channel | Local MQ Channel | DEV.APP.SVRCONN | No
| global.mqaccess.user | Local MQ username | app | No
| global.mqaccess.password | Local MQ password | passw0rd | No
| global.mqaccess.secret.name | Local MQ secret with MQ password | traderlite-localmq-secret | No


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.


## Installing an instance of the app

You can install an instance of the app  by creating a Custom Resource with the 2 required values after the operator has been installed.

```bash
cat <<EOF | oc create -f -
apiVersion: operators.clouddragons.com/v1
kind: TraderLite
metadata:
  name: traderlite
spec:
  stockQuoteMicroservice:
    apic:
      clientId: 23tyU...
      url: https://....
EOF
```

This sets the Custom Resource instance name to `traderlite` and creates all Kubernetes resources required for the app.

## Uninstalling the Chart

The app can be uninstalled by deleting the Custom Resource instance  used to install it

```bash
$ oc delete TraderLite/traderlite
```

## How the Operator was built

The operator was built from the Helm chart in the **helm-charts** subfolder using the following resources for guidance:

- [Build Kubernetes Operators from Helm Charts in 5 steps](https://www.openshift.com/blog/build-kubernetes-operators-from-helm-charts-in-5-steps)

- [IBM Stock Trader Operator](https://github.com/IBMStockTrader/stocktrader-operator)
  - **Note:** Adaptions were made to the approach documented at this link to include all prerequisites (eg databases, local MQ etc) in the operator so everything can be installed with a single command.
