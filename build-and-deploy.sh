docker build -t baio/ride-better-web-api .
docker tag baio/ride-better-web-api gcr.io/rb_gce/ride-better-web-api-1
gcloud preview docker push gcr.io/rb_gce/ride-better-web-api-1
#sudo docker push baio/ride-better-web-api
gcloud preview container replicationcontrollers resize web-api-controller --num-replicas=0
sh gce/create-controller.sh