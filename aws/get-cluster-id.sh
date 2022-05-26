#!/bin/bash

set -e

if [ ! -z "$DEBUG" ] ; then
    set -x
fi

kubectl wait --for=condition=ready clusters.cluster.x-k8s.io ${CLUSTER_NAME}
URL=$(kubectl get clusters.cluster.x-k8s.io ${CLUSTER_NAME} -o=jsonpath='{.spec.controlPlaneEndpoint.host}')
if [ -z "$URL" ]
then
      echo Could not find URL
      exit 1
fi
echo Found URL of $URL
CLUSTER_ID=$(echo $URL | sed 's/.*https:\/\///; s/\..*//')
echo cluster id is $CLUSTER_ID
echo "EKS_CLUSTER_ID=$CLUSTER_ID" > /tmp/env_config