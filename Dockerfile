# [START all]
FROM node:4.4

# Packages
RUN apt-get update && apt-get install -y \
  libaio1 \
  curl \
  xz-utils \
  unzip

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
WORKDIR /usr/projects

# [END all]