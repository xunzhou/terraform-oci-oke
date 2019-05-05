# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

resource null_resource "is_worker_active" {
  triggers = {
    bastion_public_ip = "${var.bastion_public_ip}"
  }

  connection {
    host        = "${var.bastion_public_ip}"
    private_key = "${file(var.ssh_private_key_path)}"
    timeout     = "40m"
    type        = "ssh"
    user        = "${var.image_operating_system == "Canonical Ubuntu"   ? "ubuntu" : "opc"}"
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f $HOME/node.active ]; do sleep 10; done",
    ]
  }

  count = "${(var.create_bastion == true) ? 1 : 0}"
}