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
for n in ${iterations}
do
	neutron net-create --tenant-id $TENANT_ID "relay network ${n}"
	echo "$(tput setaf 1)Creating network ${n}$(tput sgr0)"
	neutron subnet-create --tenant-id $TENANT_ID --name "relay network ${n} subnet" --dns-nameserver 8.8.8.8 --enable-dhcp "relay network ${n}" 10.0.0.0/24
	echo "$(tput setaf 2)Creating a subent for network ${n}"
	neutron router-interface-add ${ROUTER_ID} "relay network ${n} subnet"
	echo "$(tput setaf 3)Attaching network ${n} to the router$(tput sgr0)"

	nova boot --flavor 10 --image ${IMAGE_ID} --security-groups Relay --key-name tim-chromebook --nic net-id=${} "tor relay ${n}"
	echo "$(tput setaf 1)Booting relay #${n}$(tput sgr0)"
done
