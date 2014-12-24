Ride Better Web Api
===================

```
docker run -d -p 27017:27017 -v /data/mongodb dockerfile/mongodb

```

```
gcloud preview container replicationcontrollers resize web-api-controller --num-replicas=0
gcloud preview container pods list

```

##Set up env variables

Any variable could be omitted if it is already set in the enviroment , or could be set / overiden as command argument.

Create / copy .env file for private env variables

```
MONGO_URI=
ELASTIC_URI=
FORECASTIO_KEY=
JWT_SECRET=
```

## Static configs

Parameters of the system (constant, not private) is in config.json file.
For every NODE_ENV could by merged from `configs\{NODE_ENV}.config.json`


## Gulp

+ Run `gulp [default, run]` - to run server
+ Run `gulp env --dev` - to copy appropriate .env file from `.env` folder & restart server


## Set configs on heroku

```
gulp env --heroku
heroku plugins:install git://github.com/ddollar/heroku-config.git
heroku config:push --overwrite --interactive
```

## Backup mongo

```
mongodump --db ride-better-dev --out C:/bkp/mongo/ride-better/v2
```

## Usefull exports

```
mongoexport -h ds053080.mongolab.com:53080 -d heroku_app31445045 -u baio -p 123 -c skimap -q "{'user.name' : 'baio'}" --out .data/spots.json
```

```
gcloud compute firewall-rules create guestbook-node-80 --allow=tcp:80 --target-tags k8s-guestbook-node
```