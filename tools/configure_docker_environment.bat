echo off

call repo_paths.cmd

IF "%~1" == ""  ( 
	echo "Missing Environment Choice. It must be local or dev" & exit 
) ELSE (
	SET CONF=%1 & echo "Environment Variable passed: %CONF%" 
)

echo "Perform Configuration Environment: %CONF%"

IF EXIST "%PATH_REPO%\docker-compose.override.yml" del %PATH_REPO%\docker-compose.override.yml & echo "Purge Pre-existing Override"

IF EXIST "%PATH_REPO%\.env" del %PATH_REPO%\.env & echo "Purge Pre-existing environment variables"

IF EXIST %PATH_REPO%\environment\.env.%CONF% copy %PATH_REPO%\environment\.env.%CONF% %PATH_REPO%\.env

IF EXIST %PATH_REPO%\environment\docker-compose.override.yml.%CONF% copy %PATH_REPO%\environment\docker-compose.override.yml.%CONF% %PATH_REPO%\docker-compose.override.yml


