# Copyright 2017, 2019 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

# ssh keys
variable "ssh_private_key_path" {}

# bastion
variable "bastion_public_ip" {}

variable "create_bastion" {}

variable "image_operating_system" {}

# prometheus operator

variable "install_prometheus" {}

variable "prometheus_helm_release_name" {}

variable "prometheus_namespace" {}

variable "prometheus_chart_version" {}