#!/bin/sh
/Users/tlittle/mongodb-osx-x86_64-2.0.2/bin/mongod --journal --port 27017 --dbpath /data/db1 --replSet mrs &
/Users/tlittle/mongodb-osx-x86_64-2.0.2/bin/mongod --journal --port 27018 --dbpath /data/db2 --replSet mrs &
/Users/tlittle/mongodb-osx-x86_64-2.0.2/bin/mongod --journal --port 27019 --dbpath /data/db3 --replSet mrs &
