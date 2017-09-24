# reco_docker

Reco on Docker Guide for Ubuntu 16.04 Host
--------------------------------------------------

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

If you want to manually set the configuration files, run the docker image for bash in terminal.
$ sudo docker run --ip=192.188.2.2 --net=reconet -h ubuntu -it universeking/reco_mme /bin/bash
After doing your changes, run the script in the docker.
# sh mme.sh

