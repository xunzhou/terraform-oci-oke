#!/bin/bash
# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

export KUBECONFIG=generated/kubeconfig

GRAFANA_USERNAME=$(kubectl -n ${prometheus_namespace} get secret ${prometheus_helm_release_name}-grafana -o jsonpath='{.data.admin-user}' | base64 --decode)
GRAFANA_PASSWORD=$(kubectl -n ${prometheus_namespace} get secret ${prometheus_helm_release_name}-grafana -o jsonpath='{.data.admin-password}' | base64 --decode)

echo 'Access Grafana: http://localhost:3000/'
echo 'Grafana Username:' $GRAFANA_USERNAME
echo 'Grafana Password:' $GRAFANA_PASSWORD

kubectl -n ${prometheus_namespace} port-forward $(kubectl -n ${prometheus_namespace} get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000
