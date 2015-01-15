[ "$1" ]

mongodump --host ds055680.mongolab.com:55680 --db ride-better-fhist --username baio --password 123 --out ~/bkp/mongodb/rb/$1/rb-fhist-$1

mongodump --host ds035270.mongolab.com:35270 --db heroku_app30712523 --username heroku_app30712523 --password ljoaof92to4efo6vrjkgrr8hl7 -c users --out ~/bkp/mongodb/rb/$1/rb-auth-$1

mongodump --host ds053080.mongolab.com:53080 --db heroku_app31445045 --username baio --password 123 -c skimap --out ~/bkp/mongodb/rb/$1/rb-main-$1
mongodump --host ds053080.mongolab.com:53080 --db heroku_app31445045 --username baio --password 123 -c resorts --out ~/bkp/mongodb/rb/$1/rb-main-$1
mongodump --host ds053080.mongolab.com:53080 --db heroku_app31445045 --username baio --password 123 -c boards --out ~/bkp/mongodb/rb/$1/rb-main-$1
mongodump --host ds053080.mongolab.com:53080 --db heroku_app31445045 --username baio --password 123 -c webcams --out ~/bkp/mongodb/rb/$1/rb-main-$1
mongodump --host ds053080.mongolab.com:53080 --db heroku_app31445045 --username baio --password 123 -c ths --out ~/bkp/mongodb/rb/$1/rb-main-$1
