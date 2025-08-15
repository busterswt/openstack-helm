#!/bin/bash

{{/*
Copyright 2019 Samsung Electronics Co., Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/}}

set -ex

HOSTNAME=$(hostname -s)
PORTNAME=octavia-health-manager-port-$HOSTNAME

HM_PORT_ID=$(openstack port show $PORTNAME -c id -f value)
HM_PORT_MAC=$(openstack port show $PORTNAME -c mac_address -f value)

echo $HM_PORT_ID > /tmp/pod-shared/HM_PORT_ID
echo $HM_PORT_MAC > /tmp/pod-shared/HM_PORT_MAC

#JD
HM_PORT_SUBNET=$(openstack port show $PORTNAME -c fixed_ips -f json | jq -r '.fixed_ips.[].subnet_id')
HM_PORT_CIDR=$(openstack subnet show $HM_PORT_SUBNET -c cidr -f value | cut -d'/' -f2)
HM_PORT_IP=$(openstack port show $PORTNAME -c fixed_ips -f json | jq -r '.fixed_ips.[].ip_address')/$HM_PORT_CIDR
 
echo $HM_PORT_IP > /tmp/pod-shared/HM_PORT_IP
#ip addr add $HM_PORT_IP dev o-hm0
