# reco_docker
Reco on Docker Guide for Ubuntu 16.04 Host

Step 1. Installing Docker. 
Please follow the instructions at https://docs.docker.com/engine/installation/

Step 2. Create the docker network for reco. 
$ sudo docker network create --driver=bridge --subnet=192.188.2.0/24 --gateway=192.188.2.1 reconet

You have two ways to get the docker images of reco. 
a. Download the docker image directly. Please follow step 3-a. 
b. Build the image from the dockerfile. Please follow step 3-b.

Step 3-a. Download the docker image from dockerhub 
$ sudo docker pull universeking/reco_hss 
$ sudo docker pull universeking/reco_mme 
$ sudo docker pull universeking/reco_spgw

Step 3-b. Download the dockerfile and build the image from dockerfiles. 
$ git clone https://github.com/linym/reco_docker.git 
$ cd /reco_docker/reco_hss && sudo docker build -t=universeking/reco_hss . 
$ cd /reco_docker/reco_mme && sudo docker build -t=universeking/reco_mme . 
$ cd /reco_docker/reco_spgw && sudo docker build -t=universeking/reco_spgw .

Step 4. Run the docker image. Mme, hss and spgw will start to execute. Note that hss must start before mme. 
$ sudo docker run --ip=192.188.2.4 --net=reconet -h ubuntu universeking/reco_hss 
$ sudo docker run --ip=192.188.2.2 --net=reconet -h ubuntu universeking/reco_mme 
$ sudo docker run --privileged -v /lib/modules:/lib/modules --ip=192.188.2.5 --net=reconet universeking/reco_spgw

--------------------------------------
If you want to manually set the configuration files or connect to real eNodeB, following the below instructions.

Step 1. Run the docker image in bash.
$ sudo docker run -it --net=none -h ubuntu --cap-add all universeking/reco_hss /bin/bash
$ sudo docker run -it --net=none -h ubuntu --privileged universeking/reco_mme /bin/bash
$ sudo docker run -it --net=none -h ubuntu --privileged -v /lib/modules:/lib/modules universeking/reco_spgw /bin/bash

Step 2. Create virtual network interface for intercommunication. The nic which is connecting to eNodeB should replace [NIC]. (eg. eth1)
$ sudo ip link add vlan_hss link [NIC] type macvtap mode bridge
$ sudo ip link add vlan_mme link [NIC] type macvtap mode bridge
$ sudo ip link add vlan_spgw link [NIC] type macvtap mode bridge

Step 3. Create virtual network interface for Internet in spgw. The nic which is connecting to Internet should replace [NIC]. (eg. eth2)
$ sudo ip link add vlan_internet link enp5s0 type macvtap mode bridge

Step 4. Bind the created virtual interface into container.
$ sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(docker ps | awk '{if ($2 == "universeking/reco_hss") print $1;}')) vlan_hss
$ sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(docker ps | awk '{if ($2 == "universeking/reco_mme") print $1;}')) vlan_mme
$ sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(docker ps | awk '{if ($2 == "universeking/reco_spgw") print $1;}')) vlan_spgw
$ sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(docker ps | awk '{if ($2 == "universeking/reco_spgw") print $1;}')) vlan_internet

Step 5. Run the starting script in each container. Note that HSS must start before MME.
## sh hss.sh 
## sh mme.sh 
## sh spgw.sh 
