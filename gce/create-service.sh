#!/bin/sh
gcloud preview container services delete web-api-service
gcloud preview container services create --config-file gce/config/web-api-service.json