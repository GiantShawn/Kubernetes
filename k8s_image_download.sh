#!/bin/bash
set -o errexit

KUBE_VERSION=latest
KUBE_PAUSE_VERSION=3.0
ETCD_VERSION=latest
DNS_VERSION=1.14.7
DASHBOARD_VERSION=v1.8.1
GRAFANA_VERSION=v4.4.3
HEAPSTER_VERSION=v1.5.0
INFLUXDB_VERSION=v1.3.3
ADDON_MGR_VERSION=v6.5
ADDON_RESIZER_VERSION=1.8.1


ARCH=amd64

QUAY_URL=quay.io/coreos
GCR_URL=gcr.io


image_list=(\
${GCR_URL}/google-containers/kube-apiserver-${ARCH}:${KUBE_VERSION}
${GCR_URL}/google-containers/kube-controller-manager-${ARCH}:${KUBE_VERSION}
${GCR_URL}/google-containers/kube-scheduler-${ARCH}:${KUBE_VERSION}
${GCR_URL}/google-containers/kube-proxy-${ARCH}:${KUBE_VERSION}
${GCR_URL}/google-containers/etcd-${ARCH}:${ETCD_VERSION}
${GCR_URL}/google-containers/pause-${ARCH}:${KUBE_PAUSE_VERSION}
${GCR_URL}/google-containers/k8s-dns-sidecar-${ARCH}:${DNS_VERSION}
${GCR_URL}/google-containers/k8s-dns-kube-dns-${ARCH}:${DNS_VERSION}
${GCR_URL}/google-containers/k8s-dns-dnsmasq-nanny-${ARCH}:${DNS_VERSION}
${GCR_URL}/google-containers/kubernetes-dashboard-${ARCH}:${DASHBOARD_VERSION}
${GCR_URL}/google-containers/heapster-grafana-${ARCH}:${GRAFANA_VERSION}
${GCR_URL}/google-containers/heapster-${ARCH}:${HEAPSTER_VERSION}
${GCR_URL}/google-containers/heapster-influxdb-${ARCH}:${INFLUXDB_VERSION}
${GCR_URL}/google-containers/kube-addon-manager-${ARCH}:${ADDON_MGR_VERSION}
${GCR_URL}/google-containers/addon-resizer:${ADDON_RESIZER_VERSION}
quay.io/coreos/flannel:v0.8.0-amd64
)

for imageName in ${image_list[@]}; 
do
        imageShortName=`echo ${imageName} | awk -F ":" '{print $1}'|awk -F "/" '{print $NF}'`
        imageShortName_ver=`echo ${imageName} | awk -F "/" '{print $NF}'`
        dir=`echo ${imageName} | awk -F ":" '{print $1}'|awk -F "/" '{print $NF;}'`
        mkdir -p ${dir}
        cat <<EOF > ${dir}/Dockerfile
FROM ${imageName}
MAINTAINER Shawn Li <shawn@shawnli.org>
EOF
        echo docker pull registry.cn-shenzhen.aliyuncs.com/sigcrash/$imageShortName
        echo docker tag registry.cn-shenzhen.aliyuncs.com/sigcrash/$imageShortName:latest $imageName
done

git add .
git commit -m "add k8s images..."
git push origin master

