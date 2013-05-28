#!/bin/sh

RPM_DIR=ovs_xenserver5.6.100sp2 
rpm -Uvh ${RPM_DIR}/*.rpm
xe-switch-network-backend openvswitch

# reboot xenserver
reboot


