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
| portfolio.image.repository | image repository |  clouddragons/portfolio-spring-microservices
| portfolio.image.tag | image tag | latest
| portfolio.image.pullPolicy | image pull policy | IfNotPresent
| portfolio.image.pullSecrets | image pull secret (for protected repository) | `nil`
| | | |
| stockQuote.image.repository | image repository | clouddragons/stock-quote-liberty
| stockQuote.image.tag | image tag | latest
| stockQuote.image.pullPolicy | image pull policy | IfNotPresent
| stockQuote.image.pullSecrets | image pull secret (for protected repository) | `nil`
| | | |
| tradr.image.repository | image repository | clouddragons/stock-quote-liberty
| tradr.image.tag | image tag | latest
| tradr.image.pullPolicy | image pull policy | IfNotPresent
| tradr.image.pullSecrets | image pull secret (for protected repository) | `nil`
| | |
| tradeHistory.image.repository | image repository | clouddragons/trade-history-python
| tradeHistory.image.tag | image tag | latest
| tradHistory.image.pullPolicy | image pull policy | IfNotPresent
| tradeHistory.image.pullSecrets | image pull secret (for protected repository) | `nil`
| |
| tradeHistory.image.repository | image repository | clouddragons/trade-history-python
| tradeHistory.image.tag | image tag | latest
| tradHistory.image.pullPolicy | image pull policy | IfNotPresent
| tradeHistory.image.pullSecrets | image pull secret (for protected repository) | `nil`
| |
| eventStreamsConsumer.image.repository | image repository | clouddragons/trade-history-python
| eventStreamsConsumer.image.tag | image tag | latest
| eventStreamsConsumer.image.pullPolicy | image pull policy | IfNotPresent
| eventStreamsConsumer.image.pullSecrets | image pull secret (for protected repository) | `nil`
| |
| ingress.host | ingress url |  `nil`



Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.


## Installing the Chart

You can install the chart by setting the current directory to the folder where this chart is located and running the following command:

```console
helm install traderlite --namespace traderlite .
```

This sets the Helm release name to `traderlite` and creates all Kubernetes resources in a namespace called `traderlite`.

## Uninstalling the Chart

```console
$ helm uninstall traderlite
```
