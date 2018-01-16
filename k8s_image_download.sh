#!/bin/bash
set -o errexit

KUBE_VERSION=v1.8.5
KUBE_PAUSE_VERSION=3.0
ETCD_VERSION=3.0.17
DNS_VERSION=1.14.5
DASHBOARD_VERSION=v1.8.0
GRAFANA_VERSION=v4.4.3
HEAPSTER_VERSION=v1.4.2
INFLUXDB_VERSION=v1.3.3

ARCH=amd64

QUAY_URL=quay.io/coreos
GCR_URL=k8s.gcr.io
ALIYUN_URL=registry.cn-hangzhou.aliyuncs.com/inspur_research


image_list=(k8s.gcr.io/kube-apiserver-${ARCH}:${KUBE_VERSION}
k8s.gcr.io/kube-controller-manager-${ARCH}:${KUBE_VERSION}
k8s.gcr.io/kube-scheduler-${ARCH}:${KUBE_VERSION}
k8s.gcr.io/kube-proxy-${ARCH}:${KUBE_VERSION}
k8s.gcr.io/etcd-${ARCH}:${ETCD_VERSION}
k8s.gcr.io/pause-${ARCH}:${KUBE_PAUSE_VERSION}
k8s.gcr.io/k8s-dns-sidecar-${ARCH}:${DNS_VERSION}
k8s.gcr.io/k8s-dns-kube-dns-${ARCH}:${DNS_VERSION}
k8s.gcr.io/k8s-dns-dnsmasq-nanny-${ARCH}:${DNS_VERSION}
k8s.gcr.io/kubernetes-dashboard-${ARCH}:${DASHBOARD_VERSION}
k8s.gcr.io/heapster-grafana-${ARCH}:${GRAFANA_VERSION}
k8s.gcr.io/heapster-${ARCH}:${HEAPSTER_VERSION}
k8s.gcr.io/heapster-influxdb-${ARCH}:${INFLUXDB_VERSION}
quay.io/coreos/flannel:v0.8.0-amd64
)

for imageName in ${image_list[@]}; 
do
  dir=`echo ${imageName} | awk -F ":" '{print $1}'|awk -F "/" '{print $2}'`
  mkdir -p ${dir}
  cat <<EOF > ${dir}/Dockerfile
  FROM ${imageName}
  MAINTAINER Shawn Li <shawn@shawnli.org>
EOF
done

git add .
git commit -m "add k8s images..."
git push origin master

