FROM ubuntu:14.04

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y sudo git wget vim iptables

RUN git clone https://gitlab.eurecom.fr/oai/openair-cn.git

#install necessary packages
RUN cd openair-cn/SCRIPTS/ && yes | ./build_spgw -f -i
RUN cd openair-cn/SCRIPTS/ && echo "\n\n\n\n\n" | ./build_mme -f -i

#copy mme config
RUN cd openair-cn/ETC && cp spgw.conf /usr/local/etc/oai && chmod 777 /usr/local/etc/oai/spgw.conf

#build spgw
RUN cd openair-cn/SCRIPTS && ./build_spgw -c

#config spgw
RUN sed -i 's/PGW_MASQUERADE_SGI                    = "no";/PGW_MASQUERADE_SGI                    = "yes";/g' /usr/local/etc/oai/spgw.conf
RUN sed -i 's/UE_TCP_MSS_CLAMPING                   = "no";/UE_TCP_MSS_CLAMPING                   = "yes";/g' /usr/local/etc/oai/spgw.conf
RUN sed -i 's/PGW_INTERFACE_NAME_FOR_SGI            = "eth3";/PGW_INTERFACE_NAME_FOR_SGI            = "eth0";/g' /usr/local/etc/oai/spgw.conf
RUN sed -i 's/SGW_INTERFACE_NAME_FOR_S11              = "lo";/SGW_INTERFACE_NAME_FOR_S11              = "eth0";/g' /usr/local/etc/oai/spgw.conf
RUN sed -i 's/SGW_IPV4_ADDRESS_FOR_S11                = "127.0.11.2\/8";/SGW_IPV4_ADDRESS_FOR_S11                = "172.16.0.4\/16";/g' /usr/local/etc/oai/spgw.conf
RUN sed -i 's/SGW_IPV4_ADDRESS_FOR_S1U_S12_S4_UP      = "192.168.11.17\/24";/SGW_IPV4_ADDRESS_FOR_S1U_S12_S4_UP      = "172.16.0.4\/16";/g' /usr/local/etc/oai/spgw.conf

CMD ["/openair-cn/SCRIPTS/run_spgw"]
