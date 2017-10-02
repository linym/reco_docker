#spgw
FROM ubuntu:16.04

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y sudo git wget vim net-tools iputils-ping iptables lsb kmod 
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install wireshark
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install phpmyadmin

RUN git clone https://github.com/RECONet/RECO

#install necessary packages
RUN echo "\n\n\n\n\n" | /RECO/SCRIPTS/build_spgw -f -i
RUN /RECO/SCRIPTS/build_mme -f -i

#copy mme config
RUN cp /RECO/ETC/spgw.conf /usr/local/etc/oai && chmod 777 /usr/local/etc/oai/spgw.conf

#build spgw
RUN /RECO/SCRIPTS/build_spgw -c

#config spgw
RUN sed -i 's/PGW_MASQUERADE_SGI                    = "no";/PGW_MASQUERADE_SGI                    = "yes";/g' /usr/local/etc/oai/spgw.conf
RUN sed -i 's/UE_TCP_MSS_CLAMPING                   = "no";/UE_TCP_MSS_CLAMPING                   = "yes";/g' /usr/local/etc/oai/spgw.conf
RUN sed -i 's/PGW_INTERFACE_NAME_FOR_SGI            = "eth3";/PGW_INTERFACE_NAME_FOR_SGI            = "eth1";/g' /usr/local/etc/oai/spgw.conf
RUN sed -i 's/SGW_INTERFACE_NAME_FOR_S11              = "lo";/SGW_INTERFACE_NAME_FOR_S11              = "eth0";/g' /usr/local/etc/oai/spgw.conf
RUN sed -i 's/SGW_IPV4_ADDRESS_FOR_S11                = "127.0.11.2\/8";/SGW_IPV4_ADDRESS_FOR_S11                = "192.188.2.5\/24";/g' /usr/local/etc/oai/spgw.conf
RUN sed -i 's/SGW_IPV4_ADDRESS_FOR_S1U_S12_S4_UP      = "192.168.11.17\/24";/SGW_IPV4_ADDRESS_FOR_S1U_S12_S4_UP      = "192.188.2.5\/24";/g' /usr/local/etc/oai/spgw.conf

#fix spgw bugs which must restart spgw
RUN echo "#!/bin/bash" > spgw.sh
RUN echo "/RECO/SCRIPTS/run_spgw &" >> spgw.sh
RUN echo "sleep 2" >> spgw.sh
RUN echo "kill -INT \$(pgrep run_spgw)" >> spgw.sh
RUN echo "kill -INT \$(pgrep spgw)" >> spgw.sh
RUN echo "sleep 2" >> spgw.sh
RUN echo "/RECO/SCRIPTS/run_spgw" >> spgw.sh


CMD ["sh", "spgw.sh"]



