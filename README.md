# Docker Compose Complete MONICA Toolchain Example 

## Overview

This repository reports a working docker compose example of whole MONICA toolchain, from data simulation to visualization. Main components are the following:

- Wristband Emulator
- SCRAL
- GOST
- MQTT Broker
- Service Catalog
- High Level Data Fusion

In particular, such example generates Crowd Heatmap calculated from Wristband locations within Woodstower geographic area (Ground Plane Position: Latitude: 45.7968451744, Longitude: 4.95029322898, 300 m x 200 m rectangle area), 
i.e. the computation of occurrency of localization within geospatial density map.

## Getting Started
<!-- Instruction to make the project up and running. -->
Ensuring that Docker Engine is correctly installed. Then, after clone current git, from bash shell go to ${REPO_ROOT}/tools folder and launch command:

```bash
${REPO_ROOT}/tools:$ sh configure_docker_environment.sh local
```

To launch development (in construction) configuration, launch:
```bash
${REPO_ROOT}/tools:$ sh configure_docker_environment.sh dev
```

### Docker

In order to run overall simulation, launch command from ${REPO_ROOT}:

```bash
${REPO_ROOT}:$ docker-compose up -d
```

### Real Time Check

The solution includes an instance of portainer, that should run on localhost:9000. Have a look on containers to check if they are correctly running or not. Then, it is possible to check with a client MQTT (e.g. MQTT.fx), 
connecting on MQTT Broker on localhost:1883, subscribing to topic: GOST_TIVOLI/Datastreams(13151)/Observations in order to control generated messages.

### TCP Server activated

The following table show the list of services with opened ports (inside subnet and forward to external connections):

| Service Name | Container Name | External Port | Internal Subnet Port | Income Connection From |
| --------------- | --------------- | --------------- | --------------- | --------------- |
| rabbit | hldf_docker_rabbit_${ENVTYPE} | ${RABBITMQ_DOCKER_PORT_DIAGNOSTIC} | 5672| hldfad_worker |
| redis | hldf_docker_cache_redis_${ENVTYPE} | ${REDISCACHE_PORT} | 6379| hldfad_worker |
| node-red | gost-node-red_${ENVTYPE} | 1880 | 1880| gost |
| mosquitto | gost-mosquitto-${ENVTYPE} | 1883 | 1883| gost, scral, hldfad_worker|
| gost-db | gost-db_${ENVTYPE}| ? | ? | gost |
| dashboard | gost_dashboard_${ENVTYPE} | 8080 | 8080| gost, hldfad_worker |
| scral | SCRAL-wb-MQTT_${ENVTYPE} | 8000 | 8000| gost, hldfad_worker |
| servicecatalog | gostemul_docker_web_${ENVTYPE} | ${WEB_GOST_PORT} | ${V_SERVER_WEB_PORT} | hldfad_worker |
| worker_db | hldf_host_workerdb_${ENVTYPE} | ${PGSQL_WORKER_PORT} | ${PGSQL_WORKER_PORT} | hldfad_worker |
| portainer | hldf_docker_portainer | ${PORTAINER_DOCKER_EXPOS_PORT} | 9000 | None |
| worker_emul_db | hldf_host_workeremul_db_${ENVTYPE} | ${PGSQL_EMUL_PORT} | ${PGSQL_EMUL_PORT} | servicecatalog |

NOTE: 
- Variables ${} are those reported in .env file. Therefore, such port can be easiliy changed;
- worker_emul_db is used only from servicecatalog, which is a temporarily replacement of the official one

## Contributing
Contributions are welcome. 

Please fork, make your changes, and submit a pull request. For major changes, please open an issue first and discuss it with the other authors.

## Affiliation
![MONICA](https://github.com/MONICA-Project/template/raw/master/monica.png)  
This work is supported by the European Commission through the [MONICA H2020 PROJECT](https://www.monica-project.eu) under grant agreement No 732350.