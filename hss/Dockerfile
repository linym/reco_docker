#hss
FROM ubuntu:16.04
MAINTAINER universeking rexlin2012001@gmail.com

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y sudo git wget php libapache2-mod-php vim

#install mysql without interaction 
RUN echo "mysql-server-5.5 mysql-server/root_password password os" | debconf-set-selections
RUN echo "mysql-server-5.5 mysql-server/root_password_again password os" | debconf-set-selections

#install necessary packages
RUN git clone https://gitlab.eurecom.fr/oai/openair-cn.git
RUN /openair-cn/SCRIPTS/build_hss -i -F

#config hss
RUN cp /openair-cn/ETC/hss.conf /usr/local/etc/oai && chmod 777 /usr/local/etc/oai/hss.conf
#setting mysql password here
RUN sed -i 's/@MYSQL_user@/root/g' /usr/local/etc/oai/hss.conf
RUN sed -i 's/@MYSQL_pass@/os/g' /usr/local/etc/oai/hss.conf
RUN cp /openair-cn/ETC/hss_fd.conf /usr/local/etc/oai/freeDiameter && chmod 777 /usr/local/etc/oai/freeDiameter/hss_fd.conf
RUN cp /openair-cn/ETC/acl.conf /usr/local/etc/oai/freeDiameter  && chmod 777 /usr/local/etc/oai/freeDiameter/acl.conf
RUN echo "ubuntu" > hostname && cp hostname /etc/hostname 
RUN echo "127.0.1.1 ubuntu.openair4G.eur ubuntu" >> /etc/hosts && echo "127.0.0.1 hss.openair4G.eur hss" >> /etc/hosts

#import database
RUN service mysql restart && mysql -u root -pos -e "CREATE DATABASE oai_db;" && mysql -u root -pos oai_db < /openair-cn/SRC/OAI_HSS/db/oai_db.sql && mysql -u root -pos -e "USE oai_db;UPDATE mmeidentity SET mmehost = 'ubuntu.openair4G.eur' WHERE idmmeidentity = '4';"

#build
RUN /openair-cn/SCRIPTS/build_hss -c

#copy starting shell
RUN echo "#!/bin/bash" > hss.sh
RUN echo "/openair-cn/SCRIPTS/check_hss_s6a_certificate /usr/local/etc/oai/freeDiameter/ hss.openair4G.eur" >> hss.sh
RUN echo "service mysql restart" >> hss.sh
RUN echo "/openair-cn/SCRIPTS/run_hss" >> hss.sh

CMD ["sh", "hss.sh"]
