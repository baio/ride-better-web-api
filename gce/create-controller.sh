#!/bin/sh
gcloud preview container replicationcontrollers delete web-api-controller
gcloud preview container replicationcontrollers create --config-file config/web-api-controller.yml
