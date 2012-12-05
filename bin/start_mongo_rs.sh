#!/bin/sh
mongod --journal --port 27017 --dbpath /data/db1 --replSet mrs &
mongod --journal --port 27018 --dbpath /data/db2 --replSet mrs &
mongod --journal --port 27019 --dbpath /data/db3 --replSet mrs &
