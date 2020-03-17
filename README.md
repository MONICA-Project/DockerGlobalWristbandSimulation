# Docker Compose Crowd Management Toolchain Example 

## Overview

This repository reports a self-consistent docker compose demonstration of whole MONICA toolchain, from data simulation to visualization, for the Crowd Management use case. Main components are reported in the following:

- [MQTT Wristband GW Emulator](https://github.com/MONICA-Project/WristbandGwMqttEmulator)
- [SCRAL](https://github.com/MONICA-Project/scral-framework) - MQTT Wristbands Module
- [GOST](https://github.com/gost/server)
- MQTT Broker ([Eclipse Mosquitto](https://mosquitto.org/))
- Service Catalog
- [High Level Data Fusion](https://github.com/MONICA-Project/HLDFAD_SourceCode)
- Common Operational Picture (COP)

In particular, such example diplays a Crowd Heatmap calculated on the basis of wristband positions genereted within the Woodstower geographic area (Ground Plane Position: Latitude: 45.7968451744, Longitude: 4.95029322898, size 300 m x 200 m rectangle area, cell size 10 m x 10 m). The whole are is subdivided in squared cells. Each cell is indexed with a row index increasing toward the North direction and a column index increasing toward the East direction. The crowd density map is calculated by counting the occurrency of wristbands positions within each cell.

The output is shown on a web map available locally.

## Disclaimer

This package shall be intended as a demonstrative software suite just to concretely allow the visualization of the results and understand the MONICA solution. 

Such solution has been tested with success on limited number of devices (less than 1100); therefore, it is not possible to guarantee 100% successful execution of solution on all kind of PC.

## Repository Contents

In the following it is reported a quick overview of the current repository in terms of folder presentation.

|Folder|Content|Link|
| ---- | -------------------------------- | ---- |
|.| Current Folder. It contains Docker Composes and environment files (*NOTE*: It is not completed before startup, see Section [started]({#getting-started})|[${REPO_ROOT}](.)|
|environment| It contains files supporting tools for beginning setup project| [${REPO_ROOT}/environment](environment)|
|volumes| Persistent Volumes for Docker containers launched (e.g. logs)| [${REPO_ROOT}/volumes](volumes)| 
|tools| Bash script to startup environment for first usage| [${REPO_ROOT}/tools](tools)|
|resources| Resource files for README and documentation|[${REPO_ROOT}/resources](resources) |

## Quick Start Guide

## Resources Requirements

In [Docker Statistics](resources/DockerStatistics.json), it is possible to check the disk occupation for each image. The total size of images on disk is around 13 GB.

Solution has been tested with success on machine Ubuntu, CentOS and Windows 10 with at least 8 GB RAM.

### Getting Started
<!-- Instruction to make the project up and running. -->
Ensuring that Docker Engine is correctly installed (see [Docker Engine Linux Page](https://docs.docker.com/install/linux/docker-ce/ubuntu/) for Linux or [Docker Desktop](https://docs.docker.com/docker-for-windows/install/) for Windows). 

Then, after having cloned the current git, from bash shell go to ${REPO_ROOT}/tools folder and type the command:

```bash
${REPO_ROOT}/tools:$ sh configure_docker_environment.sh local
```

or under Windows Command Prompt:

```console
%REPO_ROOT%> configure_docker_environment.bat local
```

To launch development environment (under construction) configuration, type:
```bash
${REPO_ROOT}/tools:$ sh configure_docker_environment.sh dev
```

or under Windows Command Prompt:

```console
%REPO_ROOT%> configure_docker_environment.bat dev
```

**NOTE**: The environment consistent for such version of repository is local; dev is set just as an example for future extension of this repository.

### Run Docker Compose Solution

After a first configuration reported in Section [Startup]({#getting-started}), in order to run overall simulation, type the command from ${REPO_ROOT}:

```bash
${REPO_ROOT}:$ docker-compose up -d
```

### Check Execution

#### COP UI Web Portal (Map)

On [COPUI localhost:8900](http://127.0.0.1:8900) there is the COP User Interface that runs and shows the evolution of crowd heatmap with refresh overlapped on a geographic map (username: admin@monica-cop.com, password: CROWD2019!).
Then, go on the bottom of the map and select Crowd Heatmap as indicated in the following screenshot. Note that the first Crowd Heatmap could take some minutes before appearing on the geographic map. 

![Crowd Heatmap UI Selection](resources/COPUI_Screenshot_SelectCrowdHeatmap.png)

The output should be similar to the following picture.

![Crowd Heatmap COP UI](resources/COPUI_Screenshot.png)

#### Real Time Check

The solution includes an instance of portainer, that should run on localhost:9000. Have a look at the containers to check if they are correctly running or not. Then, it is possible to check with a client MQTT (e.g. [MQTT.fx](https://mqttfx.jensd.de/)), 
connecting to MQTT Broker on localhost:1883, subscribing to topic: ${V_APPSETTING_GOST_NAME}/Datastreams(13151)/Observations. 
In the following, the default configuration to retrieve output: 
- **Crowd Heatmap Output Topic**: GOST/Datastreams(13151)/Observations
- **MQTT URL**: 127.0.0.1:1883

### Stop Docker Compose Solution

To stop simulation, launch command from ${REPO_ROOT}:

```bash
${REPO_ROOT}:$ docker-compose down
```

### Clean up Resources after shutdown

If the historical informationm of previous running are not interested, on folder [tools](tools) it has been added purge script to clean up folder after usage and shutdown. 

From bash shell, launch:

```bash
${REPO_ROOT}/tools:$ sh purge.sh
```

**NOTE**: such script performs pruning of unused docker resources and it is useful to prevent big size occupation on disk after very long usage (more than 20 hours).

## Environment Variables

Detailed documentation about environment variables is available in repositories and dockerhubs readme (check Section [Repository and Dockerhub](#source-code-repository-and-dockerhub-images)). 

In the following are reported some useful variables reported in .env file generated after startup procedure. It allows to modify the behaviour of the simulation. Handle with care!

| Environment Variable | Meaning | Default Value | Note|
| --------------- | --------------- | --------------- |--------------- |
|V_COUNT_WRISTBANDS|Number of Emulated Wristband|1000| Avoid to set number greater than 1100 |
|V_BURST_INTERVAL_SECS|Interval sending burst interval| 40| Avoid to set number lower than 30|

**NOTE**: This solution has been tested with success with default values reported in the table. It has to be remarked that bigger variation of such numbers have not been validated and can compromise the execution of the demonstration and as a consequence increase required computational resources.

## Crowd Heatmap Output explaination

A simple example is shown in figure below. The points represents the location of each person/wristband with respect to the Ground Plane Position. 

![Density Map Figure](resources/chart_enudistributions.jpg)

Considering the ground plane position unknown and geographic area of 500 m x 500 m with cells 100 m x 100 m, the corresponding generated density map is:

|  | 0 | 1 | 2 | 3 | 4 |
| :---- | ---- | ---- | ---- | ---- | ---- |
| **4**| 0 | 0 | 0 | 0 | 0 |
| **3**| 0 | 0 | 0 | 0 | 0 |
| **2**| 0 | 0 | 0 | 0 | 0 |
| **1**| 4 | 1 | 1 | 1 | 1 |
| **0**| 2 | 0 | 0 | 0 | 0 |

Note that each cell is indexed with a row index increasing toward the North direction and a column index increasing toward the East direction. Cell(0,0) represents the Ground Plane Position. For instance, following this nomenclature, within the Cell (Row=0, Col=1) there are 4 people/wristbands in a space of 100 m x 100 m, 100 m North and 0 m East with respect to the Ground Plane Position.

## Docker Compose Contents

The following table shows the list of services and minimum explaination as they appears on docker-compose.yml and docker-compose.override.yml:

| Service Name | Container Name | Short Description | Links | Depends on |
| --------------- | --------------- | --------------- | --------------- | --------------- |
| hldfad_worker| hldf_docker_celery_worker_${ENVTYPE} | High Level Data Fusion and Anomaly Detection Core | rabbit, redis, mosquitto, dashboard, worker_db, servicecatalog | rabbit, redis, mosquitto, dashboard, scral, wb_mqtt_emulator, servicecatalog|
| rabbit | hldf_docker_rabbit_${ENVTYPE} | Rabbit For Queue Management (support for hldfad_worker celery tasks) | None | None |
| redis | hldf_docker_cache_redis_${ENVTYPE} | Temporarily cache for hldfad_worker | None| None |
| node-red | gost-node-red_${ENVTYPE} |  | None| None |
| mosquitto | gost-mosquitto-${ENVTYPE} | Broker MQTT as a middleware for SCRAL and hldfad_worker | None | None |
| gost-db | gost-db_${ENVTYPE} | DB for GOST | None | None |
| gost | gost-gostreal_${ENVTYPE} | Real GOST Engine | None | mosquitto, gost-db |
| dashboard | gost_dashboard_${ENVTYPE} | Web services to get GOST Catalog with Things and Datastreams | None | gost |
| scral | SCRAL-wb-MQTT_${ENVTYPE} | SCRAL protocol adapter-middleware | None | dashboard, gost, mosquitto |
| copdb | copdb_docker_${ENVTYPE} | COP DB | None | None |
| copapi | copapi_docker_${ENVTYPE} | *Missing* | None | mosquitto, gost, copdb |
| copui | copapi_docker_${ENVTYPE} | COP User Interface (Map View) | None | mosquitto, gost, copdb,copapi |
| copupdater | copupdater_docker_${ENVTYPE} | *Missing* | None | copapi, gost, mosquitto,copdb |
| servicecatalog | wp6_servicecatalogemul_docker_${ENVTYPE} | WP6 Service Catalog (temporarily) | worker_emul_db | worker_emul_db |
| worker_db | hldf_host_workerdb_${ENVTYPE} | PosgreSQL Database used by hldfad_worker to store output | None | None |
| portainer | hldf_docker_portainer | ${PORTAINER_DOCKER_EXPOS_PORT} | 9000 | None |
| worker_emul_db | hldf_host_workeremul_db_${ENVTYPE} | PosgreSQL Database to support servicecatalog  | None | servicecatalog |
| wb_mqtt_emulator | WB-MQTT-Emulator | Wristband Observations Generator Emulator | mosquitto | dashboard,gost,mosquitto,scral |

**NOTE**: *worker_emul_db* is used only from servicecatalog, which is a temporarily replacement of the official one (WP6 GOST Service Catalog)

## Source Code Repository and DockerHub Images

The followind table provides link for Docker Hub images and Git Hub Source Code repository. They include documentation about such services. Please, refers to them for detailed information not reported hereafter.

| Service Name | DockerHub Image | GitHub SourceCode |
| --------------- | --------------- | --------------- |
| hldfad_worker| [monicaproject/hldfad_worker](https://hub.docker.com/repository/docker/monicaproject/hldfad_worker) | [HLDFAD Open Source Repository](https://github.com/MONICA-Project/HLDFAD_SourceCode)  |
| scral | [monicaproject/scral](https://hub.docker.com/repository/docker/monicaproject/scral) | [SCRAL Open Source Repository](https://github.com/MONICA-Project/scral-framework)|
| servicecatalog | [monicaproject/servicecatalogemulator](https://hub.docker.com/repository/docker/monicaproject/servicecatalogemulator) | [Service Catalog Open Source Repository](https://github.com/MONICA-Project/GostScralMqttEmulator)|
| wb_mqtt_emulator | [monicaproject/wb_mqtt_emulator](https://hub.docker.com/repository/docker/monicaproject/wb_mqtt_emulator) | [Wristband Gateway MQTT Emulator Open Source Repository](https://github.com/MONICA-Project/WristbandGwMqttEmulator) |
| copdb | [monicaproject/example-databases](https://hub.docker.com/repository/docker/monicaproject/example-databases) | *Missing* |
| copapi | [monicaproject/copapi](https://hub.docker.com/repository/docker/monicaproject/copapi) | [GitHub COPAPI Repository](https://github.com/MONICA-Project/COP.API) |
| copupdater | [monicaproject/copupdater](https://hub.docker.com/repository/docker/monicaproject/copupdater)  | [GitHub COPUI Repository](https://github.com/MONICA-Project/COPUpdater) |
| copui | [monicaproject/monica-cop-examples](https://hub.docker.com/repository/docker/monicaproject/monica-cop-examples) | [GitHub COPUI Repository](https://github.com/MONICA-Project/COP-UI) |

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
| copapi | Service | 8800 | 80 | copupdater |
| copui | Service | 8900 | 8080 | copapi |
| worker_emul_db | Diagnostic | ${PGSQL_EMUL_PORT} | ${PGSQL_EMUL_PORT} | servicecatalog |

**NOTE**:

- Variables ${} are those reported in .env file. Therefore, such port can be easiliy changed;
- worker_emul_db is used only from servicecatalog, which is a temporarily replacement of the official one (WP6 GOST Service Catalog)

## Contributing
Contributions are welcome. 

Please fork, make your changes, and submit a pull request. For major changes, please open an issue first and discuss it with the other authors.

## Affiliation
![MONICA](https://github.com/MONICA-Project/template/raw/master/monica.png)  
This work is supported by the European Commission through the [MONICA H2020 PROJECT](https://www.monica-project.eu) under grant agreement No 732350.
| copdb | Service | ${PORTAINER_DOCKER_EXPOS_PORT} | 9000 | None | 
