# MariaDB

[MariaDB](https://mariadb.org) is one of the most popular database servers in the world. It’s made by the original developers of MySQL and guaranteed to stay open source. Notable users include Wikipedia, Facebook and Google.

MariaDB is developed as open source software and as a relational database it provides an SQL interface for accessing data. The latest versions of MariaDB also include GIS and JSON features.

## Introduction

This chart is a fork of the [MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) to support ARMv7.

This chart bootstraps a [MariaDB](https://github.com/peterhuene/arm-charts/tree/master/stable/mariadb/docker) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/mariadb
```

The command deploys MariaDB on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the MariaDB chart and their default values.

| Parameter                   | Description                                | Default                                                    |
| -----------------------     | ----------------------------------         | ---------------------------------------------------------- |
| `image`                     | MariaDB image                              | `peterhuene/mariadb-arm:{VERSION}`                         |
| `imagePullPolicy`           | Image pull policy.                         | `IfNotPresent`                                             |
| `usePassword`               | Enable password authentication             | `true`                                                     |
| `mariadbRootPassword`       | Password for the `root` user.              | Randomly Generated                                         |
| `mariadbUser`               | Username of new user to create.            | `nil`                                                      |
| `mariadbPassword`           | Password for the new user.                 | `nil`                                                      |
| `mariadbDatabase`           | Name for new database to create.           | `nil`                                                      |
| `persistence.enabled`       | Use a PVC to persist data                  | `true`                                                     |
| `persistence.existingClaim` | Use an existing PVC                        | `nil`                                                      |
| `persistence.storageClass`  | Storage class of backing PVC               | `nil` (uses alpha storage class annotation)                |
| `persistence.accessMode`    | Use volume as ReadOnly or ReadWrite        | `ReadWriteOnce`                                            |
| `persistence.size`          | Size of data volume                        | `8Gi`                                                      |
| `resources`                 | CPU/Memory resource requests/limits        | Memory: `256Mi`, CPU: `250m`                               |
| `config`                    | Multi-line string for my.cnf configuration | `nil`                                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set mariadbRootPassword=secretpassword,mariadbUser=my-user,mariadbPassword=my-password,mariadbDatabase=my-database \
    stable/mariadb
```

The above command sets the MariaDB `root` account password to `secretpassword`. Additionally it creates a standard database user named `my-user`, with the password `my-password`, who has access to a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/mariadb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Custom my.cnf configuration

The Bitnami MariaDB image allows you to provide a custom `my.cnf` file for configuring MariaDB.
This Chart uses the `config` value to mount a custom `my.cnf` using a [ConfigMap](http://kubernetes.io/docs/user-guide/configmap/).
You can configure this by creating a YAML file that defines the `config` property as a multi-line string in the format of a `my.cnf` file.
For example:

```bash
cat > mariadb-values.yaml <<EOF
config: |-
  [mysqld]
  max_allowed_packet = 64M
  sql_mode=STRICT_ALL_TABLES
  ft_stopword_file=/etc/mysql/stopwords.txt
  ft_min_word_len=3
  ft_boolean_syntax=' |-><()~*:""&^'
  innodb_buffer_pool_size=2G
EOF

helm install --name my-release -f mariadb-values.yaml stable/mariadb
```

## Persistence

The [MariaDB](https://github.com/peterhuene/arm-charts/tree/master/stable/mariadb/docker) image stores the MariaDB data and configurations at the `/var/lib/mariadb` path of the container.

The chart mounts a [Persistent Volume](kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning, by default. An existing PersistentVolumeClaim can be defined.

### Existing PersistentVolumeClaims

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart
```bash
$ helm install --set persistence.existingClaim=PVC_NAME postgresql
```
