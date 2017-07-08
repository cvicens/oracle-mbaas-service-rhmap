# [START all]
FROM node:4.4

# Import the public key used by the package management system.
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

# Create a list file for MongoDB.
#RUN echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list

# Packages
RUN apt-get update && apt-get install -y \
  libaio1 \
  curl \
  xz-utils \
  unzip \
  mongodb-org \
  redis-server

# Install FHC
RUN npm install -g fh-fhc
RUN npm install -g grunt-cli

# Install Oracle Instant Client
ENV ORACLE_INSTANT_CLIENT_VERSION 12.2.0.1.0
ENV INSTANT_CLI_BAS instantclient-basic-linux.x64-$ORACLE_INSTANT_CLIENT_VERSION
ENV INSTANT_CLI_SDK instantclient-sdk-linux.x64-$ORACLE_INSTANT_CLIENT_VERSION

RUN mkdir /opt/oracle

COPY ./$INSTANT_CLI_BAS.zip /opt/oracle
COPY ./$INSTANT_CLI_SDK.zip /opt/oracle

RUN cd /opt/oracle && unzip ./$INSTANT_CLI_BAS.zip && rm ./$INSTANT_CLI_BAS.zip
RUN cd /opt/oracle && unzip ./$INSTANT_CLI_SDK.zip && rm ./$INSTANT_CLI_SDK.zip

RUN cd /opt/oracle && mv instantclient_12_2 instantclient
RUN cd /opt/oracle/instantclient && ln -s libclntsh.so.12.1 libclntsh.so

ENV LD_LIBRARY_PATH /opt/oracle/instantclient:$LD_LIBRARY_PATH

# Create app directory
RUN mkdir -p /usr/projects

ADD projects/oracle-test /usr/projects/oracle-test
RUN cd /usr/projects/oracle-test && npm install

WORKDIR /usr/projects

# Dir for mongodb data
ENV MONGODB_DATA_DIR /root/data/db/
RUN mkdir -p $MONGODB_DATA_DIR

## Init using entrypoint
RUN mkdir /docker-entrypoint-init.d
ADD init.sh /docker-entrypoint-init.d/
RUN ["chmod", "+x", "/docker-entrypoint-init.d/init.sh"]
ENTRYPOINT /docker-entrypoint-init.d/init.sh
#CMD /docker-entrypoint-init.d/init.sh

# [END all]