#!bin/bash

sudo ip link add eth0 link enp2s0 type macvtap mode bridge
sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_hss") print $1;}')) eth0
sudo ip link add eth0 link enp2s0 type macvtap mode bridge
sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_mme_new") print $1;}')) eth0
sudo ip link add eth0 link enp2s0 type macvtap mode bridge
sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_location_human") print $1;}')) eth0
sudo ip link add eth0 link enp2s0 type macvtap mode bridge
sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_spgw") print $1;}')) eth0
sudo ip link add eth1 link enp4s0 type macvtap mode bridge
sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_spgw") print $1;}')) eth1
sed -i 's/PGW_INTERFACE_NAME_FOR_SGI            = "eth0";/PGW_INTERFACE_NAME_FOR_SGI            = "eth1";/g' /usr/local/etc/oai/spgw.conf
sudo ip link add eth0 link enp2s0 type macvtap mode bridge
sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/mysql") print $1;}')) eth0


