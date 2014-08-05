#!/bin/bash
set -x

TENANT_ID=
ROUTER_ID=
IMAGE_ID=

# number of relays and networks to create
iterations=20

source ./environment.rc


# create a new network and subnet, then connect them to the router
neutron net-create --tenant-id $TENANT_ID "relay network ${n}"
neutron subnet-create --tenant-id $TENANT_ID --name "relay network ${n} subnet" --dns-nameserver 8.8.8.8 --enable-dhcp "relay network ${n}" 10.0.0.0/24
neutron router-interface-add ${ROUTER_ID} "relay network ${n} subnet"

