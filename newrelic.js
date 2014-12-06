/**
 * New Relic agent configuration.
 *
 * See lib/config.defaults.js in the agent distribution for a more complete
 * description of configuration variables and their potential values.
 */
exports.config = {
  /**
   * Array of application names.
   */
  app_name : ['ride-better-web-api'],
  /**
   * Your New Relic license key.
   */
  license_key : 'f4aa0b0e9c9c68d152a48c260f2270bf0e6be1ba',
  logging : {
    /**
     * Level at which to log. 'trace' is most useful to New Relic when diagnosing
     * issues with the agent, 'info' and higher will impose the least overhead on
     * production applications.
     */
    level : 'info'
  }
};
/*
id: "web-api-controller"
kind: "ReplicationController"
apiVersion: "v1beta1"
desiredState: 
  replicas: 3
  replicaSelector: 
    name: "web-api-controller"
  podTemplate: 
    desiredState: 
      manifest: 
        version: "v1beta1"
        id: "web-api-controller"
        containers: 
          -           
            name: "web-api-controller"
            image: "baio/ride-better-web-api"
            cpu: 10000
            restartPolicy: "always"
            ports: 
              - 
                name: "web-api-port"
                containerPort: 8001
                hostPort: 8001
            env:
              - name: "NODE_ENV"
                value: "gce-stage"
              - name: "MONGO_URI"
                value: "mongodb://104.155.3.152/ride-better-stage"
              - name: "REDUCED_MONGO_URI"
                value: "mongodb://104.155.3.152/ride-better-stage"
              - name: "WEBCAMS_MONGO_URI"
                value: "mongodb://104.155.3.152/ride-better-stage"
              - name: "ELASTIC_URI"
                value: "130.211.72.105:9200"
              - name: "PORT"
                value: "8001"
              - name: "FORECASTIO_KEY"
                value: "c627c992deb04400940b50c6e1ee0562"
labels: 
  name: "web-api"
*/  
