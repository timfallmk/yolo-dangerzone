#!/bin/bash
set -x

TENANT_ID=c70abe88ef094f999adb4d3eb4d01725
ROUTER_ID=8f67ee65-32c2-4191-9d43-5db7abcef9f1
IMAGE_ID=125042ad-fe8f-48f1-9fb6-8c6ba19c2427

# number of relays and networks to create
iterations=20

source ./environment.rc


# create a new network and subnet, then connect them to the router
neutron net-create --tenant-id $TENANT_ID "relay network ${n}"
neutron subnet-create --tenant-id $TENANT_ID --name "relay network ${n} subnet" --dns-nameserver 8.8.8.8 --enable-dhcp "relay network ${n}" 10.0.0.0/24
neutron router-interface-add ${ROUTER_ID} "relay network ${n} subnet"

nova boot --flavor 10 --image ${IMAGE_ID} --security-groups relay --key-name tim-chromebook --nic <net-id=${}> "tor relay ${n}"
