Ride Better Web Api
===================

## Config Vars

`.env` file with following variables should be created in root 

```
NODE_ENV=
MONGO_URI=
ELASTIC_URI=
FORECASTIO_KEY=
REDUCED_MONGO_URI=
WEBCAMS_MONGO_URI=
AZURE_STORAGE_ACCOUNT=dataavail
AZURE_STORAGE_ACCESS_KEY=rwdE+L8oCXMnuCPVbFudvRDt28fqEjl9KVKbA+ZzcbVGYZQ6OR7YyK95Pk+QSNGEsgb3k6ZL4wctZFz5bhl26A==
```

#Initialize es data

Commands should be executed in `scripts/es` dir

1. Export data from mongo `skimap` collection
`mongoexport --host ds053080.mongolab.com:53080 --db heroku_app31445045  --collection skimap --out "./spots.json"`
2. Create `bulk.txt` file
`coffee spots-es-bulk.coffee`
3. create `rmap` index 
`curl -XPUT https://m09vdd3s:aohppx2un3q90oa3@maple-9608858.us-east-1.bonsai.io/rspots/ --data-binary @es-spots-index.json`
4. import data from buld to  elastic search
`curl https://m09vdd3s:aohppx2un3q90oa3@maple-9608858.us-east-1.bonsai.io:443/_bulk --data-binary @bulk.txt`
 
# OLD STUFF HERE

Forwarding rule must be created once per project! 

Network Load Balancing - cluster pool ports - 85-86

gcloud config set project PROJECT

gcloud config set compute/zone europe-west1-b
gcloud preview container clusters create rb-satge --num-nodes 3 --machine-type n1-standard-1


docker run -d -p 85:8080 --env-file .envs/stage.env baio/ride-better-web-api 

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


## Usefull exports

```
mongoexport -h ds053080.mongolab.com:53080 -d heroku_app31445045 -u baio -p 123 -c skimap -q "{'user.name' : 'baio'}" --out .data/spots.json
```

```
gcloud compute firewall-rules create guestbook-node-80 --allow=tcp:80 --target-tags k8s-guestbook-node
```