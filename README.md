# ARMv7 Compatible Helm Charts

This repository contains Helm charts that are compatible for ARMv7 devices, such as the Raspberry Pi 2/3.

## Kubernetes Helm
[Kubernetes Helm](https://github.com/kubernetes/helm) is a package manager for deploying software on a Kubernetes cluster.

## Installing Helm on ARMv7

At the time of this writing, Helm does not support installing on ARMv7 via the install script.

However, an ARMv7 build of Helm can be installed manually:

```
$ export HELM_VERSION=v2.5.0
$ export HELM_INSTALL_DIR=~/bin
$ wget https://kubernetes-helm.storage.googleapis.com/helm-$HELM_VERSION-linux-arm.tar.gz
$ tar xvzf helm-$HELM_VERSION-linux-arm.tar.gz
$ mv linux-arm/helm $HELM_INSTALL_DIR/helm
$ rm -rf linux-arm
```

The above extracts the `helm` binary and puts it in `$HELM_INSTALL_DIR` (assumed to be on PATH).

## Initializing Helm with an ARMv7 Tiller

Tiller is the component of Helm that runs inside of the Kubernetes cluster to administer the software releases.

Tiller is normally installed into your cluster when you execute `helm init`.  However, at the time of this writing, Helm needs to be instructed to use a ARMv7 Tiller image because it does not automatically use the correct image (see [Helm Issue #1948](https://github.com/kubernetes/helm/issues/1948)).

To instruct Helm to install an ARMv7 Tiller image:

```
$ helm init --tiller-image=peterhuene/tiller-arm:$HELM_VERSION
```

Note: currently an ARMv7 Tiller image has been built for Helm version `v2.4.1` and `v2.5.0`.

To confirm Helm is now installed correctly, run `helm version` after the tiller pod has deployed:

```
$ helm version
Client: &version.Version{SemVer:"v2.4.1", GitCommit:"46d9ea82e2c925186e1fc620a8320ce1314cbb02", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.4.1", GitCommit:"46d9ea82e2c925186e1fc620a8320ce1314cbb02", GitTreeState:"clean"}
```

## Adding the ARM chart repository

Add the ARM chart repository to Helm:

```
$ helm repo add arm-stable https://peterhuene.github.io/arm-charts/stable
"arm-stable" has been added to your repositories
```

## Installing ARM charts

Use Helm to install ARM charts:

```
$ helm install arm-stable/mariadb
```

