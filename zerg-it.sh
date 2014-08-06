#!/bin/bash
set -x

TENANT_ID=c70abe88ef094f999adb4d3eb4d01725
ROUTER_ID=8f67ee65-32c2-4191-9d43-5db7abcef9f1
IMAGE_ID=125042ad-fe8f-48f1-9fb6-8c6ba19c2427

# number of relays and networks to create
iterations=20
echo "$(tput setaf 1)We're creating ${iterations} of these things$(tput sgr0)"

source ./environment.rc


# create a new network and subnet, then connect them to the router
for i in {1..20}
do
	neutron net-create --tenant-id $TENANT_ID "relay network ${i}"
	echo "$(tput setaf 1)Creating network ${i}$(tput sgr0)"
	neutron subnet-create --tenant-id $TENANT_ID --name "relay network ${i} subnet" --dns-nameserver 8.8.8.8 --enable-dhcp "relay network ${i}" 10.0.0.0/24
	echo "$(tput setaf 2)Creating a subent for network ${i}"
	neutron router-interface-add ${ROUTER_ID} "relay network ${i} subnet"
	echo "$(tput setaf 3)Attaching network ${i} to the router$(tput sgr0)"
	NETWORK_ID=$(neutron net-show "relay network ${i}" --format shell | grep -w 'id=' | awk -F "=" '{print $2}' | tr -d \")

	nova boot --flavor 10 --image ${IMAGE_ID} --security-groups Relays --key-name tim-chromebook --nic net-id=${NETWORK_ID} "tor relay ${i}"
	echo "$(tput setaf 1)Booting relay #${i}$(tput sgr0)"
	
	sleep 30
done
