FROM ubuntu:14.04
MAINTAINER yshsueh y51563118.cs01@g2.nctu.edu.tw

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y sudo git wget vim 
RUN git clone https://gitlab.eurecom.fr/oai/openair-cn.git

RUN cd openair-cn/SCRIPTS/ && echo "\n\n\n\n\n" | ./build_hss -F -i && yes | ./build_mme -i
RUN cd openair-cn/ETC && cp mme.conf /usr/local/etc/oai && cp mme_fd.conf /usr/local/etc/oai/freeDiameter && chmod 777 /usr/local/etc/oai/mme.conf && chmod 777 /usr/local/etc/oai/freeDiameter/mme_fd.conf

#build necessary packages
RUN apt-get install -y libmnl-dev
RUN git clone git://git.osmocom.org/libgtpnl
RUN cd ./libgtpnl && autoreconf -fi && ./configure && make && make install

#fix bugs
RUN sed -i 's/bcstrfree(pid_dir);/\/\/bcstrfree(pid_dir);/g' /openair-cn/SRC/OAI_MME/oai_mme.c

#compile mme
RUN cd openair-cn/SCRIPTS && ./build_mme -c

#config mme
RUN sed -i 's/yang.openair4G.eur/ubuntu.openair4G.eur/g' /usr/local/etc/oai/freeDiameter/mme_fd.conf
RUN echo "ubuntu" > hostname && cp hostname /etc/hostname
RUN echo "127.0.1.1 ubuntu.openair4G.eur ubuntu" >> /etc/hosts && echo "127.0.0.1 hss.openair4G.eur hss" >> /etc/hosts
RUN echo "#!/bin/bash" > mme.sh
RUN echo "/openair-cn/SCRIPTS/check_mme_s6a_certificate /usr/local/etc/oai/freeDiameter/ ubuntu.openair4G.eur" >> mme.sh
RUN echo "/openair-cn/SCRIPTS/run_mme" >> mme.sh

#config network
RUN sed -i 's/MME_IPV4_ADDRESS_FOR_S1_MME           = "192.168.11.17\/24";/MME_IPV4_ADDRESS_FOR_S1_MME           = "172.16.0.3\/16";/g' /usr/local/etc/oai/mme.conf
RUN sed -i 's/MME_INTERFACE_NAME_FOR_S11_MME        = "lo";/MME_INTERFACE_NAME_FOR_S11_MME        = "eth0";/g' /usr/local/etc/oai/mme.conf
RUN sed -i 's/MME_IPV4_ADDRESS_FOR_S11_MME          = "127.0.11.1\/8";/MME_IPV4_ADDRESS_FOR_S11_MME          = "172.16.0.3\/16";/g' /usr/local/etc/oai/mme.conf
RUN sed -i 's/SGW_IPV4_ADDRESS_FOR_S11                = "127.0.11.2\/8";/SGW_IPV4_ADDRESS_FOR_S11                = "172.16.0.4\/16";/g' /usr/local/etc/oai/mme.conf
RUN sed -i 's/ConnectPeer= "hss.openair4G.eur" { ConnectTo = "127.0.0.1";/ConnectPeer= "hss.openair4G.eur" { ConnectTo = "172.16.0.2";/g' /usr/local/etc/oai/freeDiameter/mme_fd.conf

CMD ["sh", "mme.sh"]

