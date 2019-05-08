#!/bin/bash
# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

export KUBECONFIG=generated/kubeconfig

echo 'Access Prometheus: http://localhost:9090/'

kubectl -n ${prometheus_namespace} port-forward $(kubectl -n ${prometheus_namespace} get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}') 9090:9090