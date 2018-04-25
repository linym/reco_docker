#!bin/bash

sudo ip link add eth0 link enp2s0 type macvtap mode bridge
sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_hss") print $1;}')) eth0
sudo ip link add eth0 link enp2s0 type macvtap mode bridge
sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_mme") print $1;}')) eth0
sudo ip link add eth0 link enp2s0 type macvtap mode bridge
sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_location") print $1;}')) eth0
sudo ip link add eth0 link enp2s0 type macvtap mode bridge
sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_spgw") print $1;}')) eth0
sudo ip link add eth1 link enp4s0 type macvtap mode bridge
sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_spgw") print $1;}')) eth1
sudo ip link add eth0 link enp2s0 type macvtap mode bridge
sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/mysql") print $1;}')) eth0
sudo ifconfig enp2s0 192.188.2.115


