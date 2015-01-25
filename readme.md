Ride Better Web Api
===================


Forwarding rule must be created once per project! 

Network Load Balancing - cluster pool ports - 85-86

gcloud config set project PROJECT

gcloud preview container clusters create rb-satge --num-nodes 3 --machine-type n1-standard-1
gcloud config set compute/zone europe-west1-c

```
sudo docker run -d -p 85:8080 --restart=always \
-e "NODE_ENV=gce-stage" \
-e "MONGO_URI=mongodb://heroku_app31445045:db9rp9npiecuson5oj9u61n233@ds053080.mongolab.com:53080/<head></head>eroku_app31445045" \
-e "REDUCED_MONGO_URI=mongodb://baio:123@ds055680.mongolab.com:55680/ride-better-fhist" \
-e "WEBCAMS_MONGO_URI=mongodb://baio:123@ds053080.mongolab.com:53080/heroku_app31445045" \
-e "ELASTIC_URI=https://m09vdd3s:aohppx2un3q90oa3@maple-9608858.us-east-1.bonsai.io" \
-e "PORT=8080" \
-e "FORECASTIO_KEY=c627c992deb04400940b50c6e1ee0562" \
-e "JWT_SECRET=allBestthings1979" \
baio/ride-better-web-api 

sudo docker run -d -p 86:8080 --restart=always \
-e "NODE_ENV=stage" \
-e "MONGOLAB_URI=mongodb://heroku_app30712523:ljoaof92to4efo6vrjkgrr8hl7@ds035270.mongolab.com:35270/heroku_app30712523" \
-e "PORT=8080" \
-e "NEW_RELIC_LICENSE_KEY=2538a9e69983d968687ce5cd757295dde68c7575" \
-e "JWT_SECRET=allBestthings1979" \
baio/auth-api 

sudo docker run -d -p 80:8080 --restart=always \
-e "NODE_ENV=gce_stage" \
-e "PORT=8080" \
-e "NEW_RELIC_LICENSE_KEY=cdc04e9a1643f8b59cbfe567de85e9fa2e7e39f8" \
baio/ride-better-web-app


docker run -t -p 27017:27017 -v /data/mongodb dockerfile/mongodb

mongodb://baio:123@ds053080.mongolab.com:53080/heroku_app31445045
heroku_app31445045:db9rp9npiecuson5oj9u61n233


mongodump --host ds055680.mongolab.com:55680 --db ride-better-fhist --username baio --password 123 --out ~/bkp/mongodb/rb/rb-fhist-1501

mongodump --host ds035270.mongolab.com:35270 --db heroku_app30712523 --username heroku_app30712523 --password ljoaof92to4efo6vrjkgrr8hl7 -c users --out ~/bkp/mongodb/rb/rb-auth-1501

mongodump --host ds053080.mongolab.com:53080 --db heroku_app31445045 --username baio --password 123 -c skimap --out ~/bkp/mongodb/rb/rb-main-1501
mongodump --host ds053080.mongolab.com:53080 --db heroku_app31445045 --username baio --password 123 -c resorts --out ~/bkp/mongodb/rb/rb-main-1501
mongodump --host ds053080.mongolab.com:53080 --db heroku_app31445045 --username baio --password 123 -c boards --out ~/bkp/mongodb/rb/rb-main-1501
mongodump --host ds053080.mongolab.com:53080 --db heroku_app31445045 --username baio --password 123 -c webcams --out ~/bkp/mongodb/rb/rb-main-1501
mongodump --host ds053080.mongolab.com:53080 --db heroku_app31445045 --username baio --password 123 -c ths --out ~/bkp/mongodb/rb/rb-main-1501




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

mongodump --host ds053080.mongolab.com --port 53080 --db heroku_app31445045 -u baio -p 123 --out C:/bkp/mongo/ride-better/07012015
```

## Usefull exports

```
mongoexport -h ds053080.mongolab.com:53080 -d heroku_app31445045 -u baio -p 123 -c skimap -q "{'user.name' : 'baio'}" --out .data/spots.json
```

```
gcloud compute firewall-rules create guestbook-node-80 --allow=tcp:80 --target-tags k8s-guestbook-node
```