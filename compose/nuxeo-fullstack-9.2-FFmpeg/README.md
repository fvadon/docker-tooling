# Nuxeo compose template   
The docker compose file enables to create a new nuxeo 9.2+pgsql application.
Some environment variables are available in the compose file, some of them are defined in the .env file.

You can override the variable default values with a simple start.sh script that can be:

```
#/bin/sh
export DEMO_NAME="demo"
export packages="nuxeo-jsf-ui nuxeo-web-ui nuxeo-drive"

docker-compose rm -f
docker-compose up -d
```

The Nuxeo server is built from the 9.2 image and includes video codecs. Data volumes are created to store the data outside of the containers
