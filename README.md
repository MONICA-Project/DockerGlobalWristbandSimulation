# Docker Compose Complete MONICA Toolchain Example 

## Overview

This repository reports a working docker compose example of whole MONICA toolchain, from data simulation to visualization. Main components are the following:

- [MQTT Wristband GW Emulator](https://github.com/MONICA-Project/WristbandGwMqttEmulator)
- [SCRAL](https://github.com/MONICA-Project/scral-framework) - MQTT Wristbands Module
- [GOST](https://github.com/gost/server)
- MQTT Broker ([Eclipse Mosquitto](https://mosquitto.org/))
- Service Catalog
- [High Level Data Fusion](https://github.com/MONICA-Project/HLDFAD_SourceCode)

In particular, such example generates Crowd Heatmap calculated from Wristband locations within Woodstower geographic area (Ground Plane Position: Latitude: 45.7968451744, Longitude: 4.95029322898, 300 m x 200 m rectangle area, cell size 10 m x 10 m), 
i.e. the computation of occurrency of localization within geospatial density map on the surface, with rows increasing with respect to the North and columns increasing with respect to East direction.

A simple example is shown in figure below. The points represents the location of each person with respect to the Ground Plane Position. 

![Density Map Figure](https://github.com/MONICA-Project/DockerGlobalWristbandSimulation/blob/master/chart_enudistributions.jpg) 

Considering the ground plane position incognite and geographic area of 500 m x 500 m with cells 100 m x 100 m, the generated density map is:

| ColIndex | 0 | 1 | 2 | 3 | 4 |
| :---- | ---- | ---- | ---- | ---- | ---- |
| **4**| 0 | 0 | 0 | 0 | 0 |
| **3**| 0 | 0 | 0 | 0 | 0 |
| **2**| 0 | 0 | 0 | 0 | 0 |
| **1**| 4 | 1 | 1 | 1 | 1 |
| **0**| 2 | 0 | 0 | 0 | 0 |

Where Cell(0,0) is the Ground Plane Position. In this case, it means that in Cell (Row=0, Col=1) there are 4 people in a space of 100 m x 100 m, 100 m North and 0 m East with respect to Ground Plane Position.

## Getting Started
<!-- Instruction to make the project up and running. -->
Ensuring that Docker Engine is correctly installed. Then, after clone current git, from bash shell go to ${REPO_ROOT}/tools folder and launch command:

```bash
${REPO_ROOT}/tools:$ sh configure_docker_environment.sh local
```

To launch development environment (under construction) configuration, launch:
```bash
${REPO_ROOT}/tools:$ sh configure_docker_environment.sh dev
```

## Docker Compose Contents

The following table shows the list of services and minimum explaination as they appears on docker-compose.yml and docker-compose.override.yml:

| Service Name | Container Name | Short Description | Links | Depends on |
| --------------- | --------------- | --------------- | --------------- | --------------- |
| hldfad_worker| hldf_docker_celery_worker_${ENVTYPE} | High Level Data Fusion and Anomaly Detection Core | rabbit, redis, mosquitto, dashboard, worker_db, servicecatalog | rabbit, redis, mosquitto, dashboard, scral, wb_mqtt_emulator, servicecatalog|
| rabbit | hldf_docker_rabbit_${ENVTYPE} | Rabbit For Queue Management (support for hldfad_worker celery tasks) | None | None |
| redis | hldf_docker_cache_redis_${ENVTYPE} | Temporarily cache for hldfad_worker | None| None |
| node-red | gost-node-red_${ENVTYPE} |  | |  |
| mosquitto | gost-mosquitto-${ENVTYPE} | Broker MQTT as a middleware for SCRAL and hldfad_worker | None | None |
| gost-db | gost-db_${ENVTYPE} | DB for GOST | None | None |
| gost | gost-gostreal_${ENVTYPE} | Real GOST Engine | None | mosquitto, gost-db |
| dashboard | gost_dashboard_${ENVTYPE} | Web services to get GOST Catalog with Things and Datastreams | None | gost |
| scral | SCRAL-wb-MQTT_${ENVTYPE} | SCRAL protocol adapter-middleware | | dashboard, gost, mosquitto |
| servicecatalog | gostemul_docker_web_${ENVTYPE} | WP6 Service Catalog (temporarily) | worker_emul_db | worker_emul_db |
| worker_db | hldf_host_workerdb_${ENVTYPE} | PosgreSQL Database used by hldfad_worker to store output | None | None |
| portainer | hldf_docker_portainer | ${PORTAINER_DOCKER_EXPOS_PORT} | 9000 | None |
| worker_emul_db | hldf_host_workeremul_db_${ENVTYPE} | PosgreSQL Database to support servicecatalog  |  | servicecatalog |
| wb_mqtt_emulator | WB-MQTT-Emulator | Wristband Observations Generator Emulator | mosquitto | dashboard,gost,mosquitto,scral |

NOTE:

- worker_emul_db is used only from servicecatalog, which is a temporarily replacement of the official one (WP6 GOST Service Catalog)

## Source Code

The followind table provides link for Docker Hub images and Git Hub Source Code repository. They include documentation about such services. Please, refers to them for detailed information not reported hereafter.

| Service Name | DockerHub Image | GitHub SourceCode |
| --------------- | --------------- | --------------- |
| hldfad_worker| [monicaproject/hldfad_worker](https://hub.docker.com/repository/docker/monicaproject/hldfad_worker) | [HLDFAD Open Source Repository](https://github.com/MONICA-Project/HLDFAD_SourceCode)  |
| scral | [monicaproject/scral](https://hub.docker.com/repository/docker/monicaproject/scral) | [SCRAL Open Source Repository](https://github.com/MONICA-Project/scral-framework)|
| servicecatalog | [monicaproject/servicecatalogemulator](https://hub.docker.com/repository/docker/monicaproject/servicecatalogemulator) | [Service Catalog Open Source Repository](https://github.com/MONICA-Project/GostScralMqttEmulator)|
| wb_mqtt_emulator | [monicaproject/wb_mqtt_emulator](https://hub.docker.com/repository/docker/monicaproject/wb_mqtt_emulator) | [Wristband Gateway MQTT Emulator Open Source Repository](https://github.com/MONICA-Project/WristbandGwMqttEmulator) |


### Docker

In order to run overall simulation, launch command from ${REPO_ROOT}:

```bash
${REPO_ROOT}:$ docker-compose up -d
```

### Real Time Check

The solution includes an instance of portainer, that should run on localhost:9000. Have a look on containers to check if they are correctly running or not. Then, it is possible to check with a client MQTT (e.g. MQTT.fx), 
connecting on MQTT Broker on localhost:1883, subscribing to topic: ${V_APPSETTING_GOST_NAME}/Datastreams(13151)/Observations. 
In the following, the default configuration to retrieve output: 
- **Crowd Heatmap Output Topic**: GOST/Datastreams(13151)/Observations
- **MQTT URL**: 127.0.0.1:1883

### TCP Server activated

The following table show the list of services with opened ports (inside subnet and forward to external connections):

| Service Name | Type Port | External Port | Internal Subnet Port | Income Connection From |
| --------------- | --------------- | --------------- | --------------- | --------------- |
| rabbit | Service | ${RABBITMQ_DOCKER_PORT_DIAGNOSTIC} | 5672| hldfad_worker |
| rabbit | Diagnostic | ${RABBITMQ_DOCKER_PORT_SERVICE} | 15672| None |
| redis | Service | ${REDISCACHE_PORT} | 6379| hldfad_worker |
| node-red | Service | 1880 | 1880| gost |
| mosquitto | Service | 1883 | 1883| gost, scral, hldfad_worker|
| mosquitto | Diagnostic | 9001 | 9001| None |
| dashboard | Service | 8080 | 8080| gost, hldfad_worker |
| scral | Service | 8000 | 8000| gost, hldfad_worker |
| servicecatalog | Service | ${WEB_GOST_PORT} | ${V_SERVER_WEB_PORT} | hldfad_worker |
| servicecatalog | Diagnostic | ${WEB_DIAGNOSTIC_PORT} | 3001 | hldfad_worker |
| worker_db | Service | ${PGSQL_WORKER_PORT} | ${PGSQL_WORKER_PORT} | hldfad_worker |
| portainer | Service | ${PORTAINER_DOCKER_EXPOS_PORT} | 9000 | None |
| worker_emul_db | Diagnostic | ${PGSQL_EMUL_PORT} | ${PGSQL_EMUL_PORT} | servicecatalog |

NOTE:

- Variables ${} are those reported in .env file. Therefore, such port can be easiliy changed;
- worker_emul_db is used only from servicecatalog, which is a temporarily replacement of the official one (WP6 GOST Service Catalog)

## Contributing
Contributions are welcome. 

Please fork, make your changes, and submit a pull request. For major changes, please open an issue first and discuss it with the other authors.

## Affiliation
![MONICA](https://github.com/MONICA-Project/template/raw/master/monica.png)  
This work is supported by the European Commission through the [MONICA H2020 PROJECT](https://www.monica-project.eu) under grant agreement No 732350.
