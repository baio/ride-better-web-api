#!/bin/sh
gcloud preview container services delete web-api-service
gcloud preview container services create --config-file config/web-api-service.yml