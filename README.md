# Purpose

This is a Vagrantfile for Ubuntu VMs.

I use this for testing Ansible Playbooks.

# Basic usage

Ensure vagrant is installed with the libvirt plugin.

Provision a Ubuntu VM with the following command:


`vagrant up --provider=libvirt`


Then use the `get-vagrant.sh` to test connectivity.
