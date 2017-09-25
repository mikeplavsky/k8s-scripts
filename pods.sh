#!/bin/bash

PODS=`kubectl get pods --all-namespaces -o json | jq '[.items[] | { name: .metadata.name, node: .spec.nodeName, status: .status.conditions[] | select(.status=="False") } | select( now - (.status.lastTransitionTime | fromdateiso8601) > 300 )] | group_by(.node) | map({ node: .[0].node, total: length })'`

if [ ${#PODS} -gt 2 ]; then
  echo "unhealthy pods: "
  echo $PODS
else 
  echo "All pods are healthy"
fi
