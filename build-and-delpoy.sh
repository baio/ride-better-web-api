sudo docker build -t baio/ride-better-web-api .
sudo docker push baio/ride-better-web-api
gcloud preview container replicationcontrollers resize web-api-controller --num-replicas=0
sh gce/create-controller.sh
