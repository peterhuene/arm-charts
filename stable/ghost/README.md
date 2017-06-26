# Ghost

[Ghost](https://ghost.org/) is one of the most versatile open source content management systems on the market.

## TL;DR;

```console
$ helm install stable/ghost
```

## Introduction

This chart bootstraps a [Ghost](https://github.com/peterhuene/arm-charts/tree/master/stable/ghost) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [MariaDB chart](https://github.com/peterhuene/arm-charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Ghost application.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/ghost
```

The command deploys Ghost on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Initial Ghost Setup

Ghost needs to be setup after the chart is installed.

To perform the initial Ghost setup, visit the `http[s]://<bloghost>/ghost`. 

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Ghost chart and their default values.

| Parameter                         | Description                                         | Default                                                   |
| --------------------------------- | --------------------------------------------------- | --------------------------------------------------------- |
| `image`                           | Ghost image                                         | `peterhuene/ghost-arm:{VERSION}`                          |
| `imagePullPolicy`                 | Image pull policy                                   | `Always` if `image` tag is `latest`, else `IfNotPresent`  |
| `ghostUrl`                        | Ghost URL (e.g. https://blog.example.com)           | **REQUIRED**                                              |
| `ghostPort`                       | The port Ghost will listen on                       | `2368`                                                    |
| # smtpHost:
# smtpPort:
# smtpUser:
# smtpPassword:
# smtpService:
| `serviceType`                     | The Kubernetes service type                         | `LoadBalancer`                                            |
| `loadBalancerIP`                  | The Kubernetes service load balancer IP             | `nil`                                                     |
| `persistence.enabled`             | Enable persistence using PVC                        | `true`                                                    |
| `persistence.storageClass`        | Storage class for Ghost volume                      | `default`                                                 |
| `persistence.accessMode`          | Access mode for Ghost volume                        | `ReadWriteOnce`                                           |
| `persistence.size`                | Size for Ghost volume                               | `8Gi`                                                     |
| `resources`                       | CPU/Memory resource requests/limits                 | Memory: `512Mi`, CPU: `300m`                              |

The above parameters map to the env variables defined in [peterhuene/ghost-arm](http://github.com/peterhuene/arm-charts/tree/master/stable/ghost-arm/docker).

> **Note**:
>
> Optionally, you can specify the `loadBalancerIP` parameter to assign a reserved IP address to the Ghost service of the chart. However please note that this feature is only available on a few cloud providers (e.g. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create ghost-public-ip
> ```
>
> The reserved IP address can be associated to the Ghost service by specifying it as the value of the `loadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release --set ghostUrl=https://blog.example.com stable/ghost
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/ghost
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Ghost](https://github.com/peterhuene/arm-charts-tree/master/stable/ghost/docker) image stores the Ghost data and configurations at the `/var/lib/ghost` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
