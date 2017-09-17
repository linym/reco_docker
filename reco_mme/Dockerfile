FROM ubuntu:16.04
MAINTAINER universeking rexlin2012001@gmail.com

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y sudo git wget vim lsb
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install wireshark phpmyadmin

RUN git clone https://github.com/RECONet/RECO

RUN echo "mysql-server mysql-server/root_password password 123" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password 123" | debconf-set-selections
RUN echo "\n\n\n\n\n" | /RECO/SCRIPTS/build_hss -F -i 
RUN yes | /RECO/SCRIPTS/build_mme -f -i
RUN cp /RECO/ETC/mme.conf /usr/local/etc/oai && chmod 777 /usr/local/etc/oai/mme.conf
RUN cp /RECO/ETC/mme_fd.conf /usr/local/etc/oai/freeDiameter && chmod 777 /usr/local/etc/oai/freeDiameter/mme_fd.conf

#build necessary packages
RUN apt-get install -y libmnl-dev
RUN git clone git://git.osmocom.org/libgtpnl
RUN cd /libgtpnl && autoreconf -fi && /libgtpnl/configure && make && make install
RUN cd /tmp && rm -rf /tmp/liblfds* && git clone https://github.com/liblfds/liblfds.git && cd liblfds/liblfds/liblfds7.1.0/liblfds710/build/gcc_gnumake && make so_dbg && rm -f /usr/local/lib//liblfds710.so && make so_install && rm -rf /tmp/liblfds*

#compile mme
RUN /RECO/SCRIPTS/build_mme -c

#config mme
RUN sed -i 's/yang.openair4G.eur/ubuntu.openair4G.eur/g' /usr/local/etc/oai/freeDiameter/mme_fd.conf
RUN echo "ubuntu" > hostname && cp hostname /etc/hostname
RUN echo "127.0.1.1 ubuntu.openair4G.eur ubuntu" >> /etc/hosts && echo "127.0.0.1 hss.openair4G.eur hss" >> /etc/hosts
RUN echo "#!/bin/bash" > mme.sh
RUN echo "/RECO/SCRIPTS/check_mme_s6a_certificate /usr/local/etc/oai/freeDiameter/ ubuntu.openair4G.eur" >> mme.sh
RUN echo "/RECO/SCRIPTS/run_mme" >> mme.sh

#config network
RUN sed -i 's/MME_IPV4_ADDRESS_FOR_S1_MME           = "192.168.11.17\/24";/MME_IPV4_ADDRESS_FOR_S1_MME           = "172.16.0.3\/16";/g' /usr/local/etc/oai/mme.conf
RUN sed -i 's/MME_INTERFACE_NAME_FOR_S11_MME        = "lo";/MME_INTERFACE_NAME_FOR_S11_MME        = "eth0";/g' /usr/local/etc/oai/mme.conf
RUN sed -i 's/MME_IPV4_ADDRESS_FOR_S11_MME          = "127.0.11.1\/8";/MME_IPV4_ADDRESS_FOR_S11_MME          = "172.16.0.3\/16";/g' /usr/local/etc/oai/mme.conf
RUN sed -i 's/SGW_IPV4_ADDRESS_FOR_S11                = "127.0.11.2\/8";/SGW_IPV4_ADDRESS_FOR_S11                = "172.16.0.4\/16";/g' /usr/local/etc/oai/mme.conf
RUN sed -i 's/ConnectPeer= "hss.openair4G.eur" { ConnectTo = "127.0.0.1";/ConnectPeer= "hss.openair4G.eur" { ConnectTo = "172.16.0.2";/g' /usr/local/etc/oai/freeDiameter/mme_fd.conf

CMD ["sh", "mme.sh"]

