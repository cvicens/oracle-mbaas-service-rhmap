#!/bin/bash
redis-server /etc/redis/redis.conf
mongod --dbpath $MONGODB_DATA_DIR &
bash
