# reco_docker
Reco on Docker Guide for Ubuntu 16.04 Host

Step 1. Installing Docker.
Please follow the instructions at https://docs.docker.com/engine/installation/
$ sudo apt-get update
$ sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
$ sudo apt-get update
$ sudo apt-get install docker-ce

Test installation
$ sudo docker run hello-world

Manage Docker as a non-root user
$ sudo groupadd docker
$ sudo usermod -aG docker $USER
Log out and log back in.

You have two ways to get the docker images of reco.
a. Download the docker image directly. Please follow step 2-a.
b. Build the image from the dockerfile. Please follow step 2-b.

Step 2-a. Download the docker image from dockerhub
$ sudo docker pull universeking/reco_hss
$ sudo docker pull universeking/reco_mme_new
$ sudo docker pull universeking/reco_location_human
$ sudo docker pull universeking/reco_spgw

Step 2-b. Download the dockerfile and build the image from dockerfiles.
$ git clone https://github.com/linym/reco_docker.git
$ sudo docker build -t universeking/reco_hss -f Dockerfile.hss .
$ sudo docker build -t universeking/reco_mme_new -f Dockerfile.mme_new .
$ sudo docker build -t universeking/reco_mme_server -f Dockerfile.location_server .
$ sudo docker build -t universeking/reco_spgw -f Dockerfile.spgw .

You have two ways to run the docker images of reco.
a. Test with oaisim. Please follow step 3-a.
b. Test with physical eNodeB and mobile phone or dongle. Please follow step 3-b.

=========Test with oaisim=========
Step 3. Create the docker network for reco.
$ sudo docker network create --driver=bridge --subnet=192.188.2.0/24 --gateway=192.188.2.1 reconet

Step 4. Run the docker image. Mme, hss and spgw will start to execute. Note that hss must start before mme.
$ sudo docker run --ip=192.188.2.4 --net=reconet -h ubuntu universeking/reco_hss
$ sudo docker run --ip=192.188.2.2 --net=reconet -h ubuntu universeking/reco_mme_new
$ sudo docker run --ip=192.188.2.6 --net=reconet -h mme3 universeking/reco_location_human
$ sudo docker run --privileged -v /lib/modules:/lib/modules --ip=192.188.2.5 --net=reconet universeking/reco_spgw

Step 5. Run oaisim
$ sudo -E ~/openairinterface5g/cmake_targets/tools/run_enb_ue_virt_s1

=========Test with physical eNodeB and mobile phone or dongle=========
Step 3. Run the docker image in bash.
$ sudo docker run -it --net=none -h ubuntu --cap-add all universeking/reco_hss /bin/bash
$ sudo docker run -it --net=none -h ubuntu --privileged universeking/reco_mme /bin/bash
$ sudo docker run -it --net=none -h mme3 --privileged universeking/reco_location_human /bin/bash
$ sudo docker run -it --net=none -h ubuntu --privileged -v /lib/modules:/lib/modules universeking/reco_spgw /bin/bash
$ sudo docker run -it --net=none -h ubuntu --cap-add all --env="MYSQL_ROOT_PASSWORD=123" universeking/mysql /bin/bash


Step 4. Create virtual network interface for intercommunication and bind the created virtual interface into container. The nic which is connecting to eNodeB should replace [NIC]. (eg. enp2s0)
$ sh network.sh

$ sudo ip link add eth0 link [NIC] type macvtap mode bridge
$ sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_hss") print $1;}')) eth0

$ sudo ip link add eth0 link [NIC] type macvtap mode bridge
$ sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_mme_new") print $1;}')) eth0

$ sudo ip link add eth0 link [NIC] type macvtap mode bridge
$ sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_location_human") print $1;}')) eth0

$ sudo ip link add eth0 link [NIC] type macvtap mode bridge
$ sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_spgw") print $1;}')) eth0

Step 5. Create virtual network interface for Internet in spgw. The nic which is connecting to Internet should replace [NIC]. (eg. enp5s0)
$ sudo ip link add eth1 link [NIC] type macvtap mode bridge
$ sudo ip link set netns $(docker inspect --format '{{.State.Pid}}' $(sudo docker ps | awk '{if ($2 == "universeking/reco_spgw") print $1;}')) eth1
$ sed -i 's/PGW_INTERFACE_NAME_FOR_SGI            = "eth0";/PGW_INTERFACE_NAME_FOR_SGI            = "eth1";/g' /usr/local/etc/oai/spgw.conf



Step 6. Activate the virtual nics in each container. Set the ip address then run the starting script. Note that HSS must start before MME.
/# sh network.sh

//hss
\#  ip link set eth0 up
\#  ifconfig eth0 192.188.2.4
\#  sh hss.sh
//mme
\#  ip link set eth0 up
\#  ifconfig eth0 192.188.2.2
\#  sh mme.sh
//location_human
\#  ip link set eth0 up
\#  ifconfig eth0 192.188.2.6
\#  sh mme.sh
//spgw
\#  ip link set eth0 up
\#  ifconfig eth0 192.188.2.5
\#  ip link set eth1 up
\#  ifconfig eth1 [IP address to Internet]
\#  sh spgw.sh
//mysql
\#  ip link set eth0 up
\#  ifconfig eth0 192.188.2.11
\#  sh mysql.sh


