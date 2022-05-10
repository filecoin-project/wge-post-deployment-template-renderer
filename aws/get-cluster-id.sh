#!/bin/bash

set -e

if [ ! -z "$DEBUG" ] ; then
    set -x
fi

kubectl wait --for=condition=ready clusters.cluster.x-k8s.io 
URL=$(kubectl get clusters.cluster.x-k8s.io test-01 -o=jsonpath='{.spec.controlPlaneEndpoint.host}')
if [ -z "$URL" ]
then
      echo Could not find URL
      exit 1
fi
echo Found URL of $URL
CLUSTER_ID=$(echo $URL | sed 's/.*https:\/\///; s/\..*//')
echo cluster id is $CLUSTER_ID
export EKS_CLUSTER_ID=$CLUSTER_ID