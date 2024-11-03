## Docker Commands
- To check if any container is running: `docker ps`
- Check all containers: `docker ps -a`
- To run docker compose file: `docker compose up -d`
- To stop docker compose file: `docker compose down`
- To stop specific container: `docker stop <CONTAINER_ID>/<CONTAINER_NAME>`
- To connect into container: `docker exec -it <CONTAINER_ID>/<CONTAINER_NAME> bash`
    > To exit from container: `exit`
- 


### .env Variables
```
# GRAFANA CONFIGURATIONS 
GRAFANA_ADMIN_PASSWORD=

# KAFKA CONFIGURATIONS
TOPIC_NAME=
PARTITION_COUNT=
REPLICA_COUNT=
CONSUMER_GROUP_ID=

# INFLUX CONFIGURATIONS
DATABASE_NAME=
```