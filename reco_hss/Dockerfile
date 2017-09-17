#hss
FROM ubuntu:16.04
MAINTAINER universeking rexlin2012001@gmail.com

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y sudo git wget php libapache2-mod-php vim lsb

#install mysql without interaction 
RUN echo "mysql-server mysql-server/root_password password 123" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password 123" | debconf-set-selections

#install necessary packages
RUN git clone https://github.com/RECONet/RECO

RUN /RECO/SCRIPTS/build_hss -i -F

#config hss
RUN cp /RECO/ETC/hss.conf /usr/local/etc/oai && chmod 777 /usr/local/etc/oai/hss.conf
#setting mysql password here
RUN sed -i 's/@MYSQL_user@/root/g' /usr/local/etc/oai/hss.conf
RUN sed -i 's/@MYSQL_pass@/123/g' /usr/local/etc/oai/hss.conf
RUN cp /RECO/ETC/hss_fd.conf /usr/local/etc/oai/freeDiameter && chmod 777 /usr/local/etc/oai/freeDiameter/hss_fd.conf
RUN cp /RECO/ETC/acl.conf /usr/local/etc/oai/freeDiameter  && chmod 777 /usr/local/etc/oai/freeDiameter/acl.conf
RUN echo "ubuntu" > hostname && cp hostname /etc/hostname 
RUN echo "127.0.1.1 ubuntu.openair4G.eur ubuntu" >> /etc/hosts && echo "127.0.0.1 hss.openair4G.eur hss" >> /etc/hosts

#import database
RUN service mysql restart && mysql -u root -p123 -e "CREATE DATABASE oai_db;" && mysql -u root -p123 oai_db < /RECO/SRC/OAI_HSS/db/oai_db.sql && mysql -u root -p123 -e "USE oai_db;UPDATE mmeidentity SET mmehost = 'ubuntu.openair4G.eur' WHERE idmmeidentity = '4';"

#build
RUN /RECO/SCRIPTS/build_hss -c

#copy starting shell
RUN echo "#!/bin/bash" > hss.sh
RUN echo "/RECO/SCRIPTS/check_hss_s6a_certificate /usr/local/etc/oai/freeDiameter/ hss.openair4G.eur" >> hss.sh
RUN echo "service mysql restart" >> hss.sh
RUN echo "/RECO/SCRIPTS/run_hss" >> hss.sh

CMD ["sh", "hss.sh"]
