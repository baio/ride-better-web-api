docker build -t baio/ride-better-web-api .
docker tag baio/ride-better-web-api:latest gcr.io/rb_gce/ride-better-web-api
gcloud preview docker push gcr.io/rb_gce/ride-better-web-api:latest
gcloud preview container replicationcontrollers resize web-api-controller --num-replicas=0
sleep 10
gcloud preview container replicationcontrollers resize web-api-controller --num-replicas=3
#sh gce/create-controller.sh