# Nuxeo compose template   
The docker compose file has variables so that it's easy to create a new nuxeo+pgsql application from a script file that could be:


```
#/bin/sh
export DEMO_NAME="demo"
export packages="nuxeo-jsf-ui nuxeo-web-ui nuxeo-drive nuxeo-vision nuxeo-diff"

docker-compose rm -f
docker-compose up
```
The Nuxeo server is built from the latest image and includes video codecs. Data volumes are created to store the data outside of the containers
