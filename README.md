# RHMAP Docker image

## Clone this repo

```
$ git clone https://github.com/cvicens/oracle-mbaas-service-rhmap
```

## Download Oracle DB Instant Client and SDK
Download the free Basic and SDK ZIPs from !(Oracle Technology Network)[http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html] and copy them in the git repo folder, it should be 'oracle-mbaas-service-rhmap'

## Create a directory to run your projects locally
You'll mount a volume when you run the docker image and this 'projects' directory will be used in the container to allow persistence.

```
$ mkdir projects
```

## Set up environment to name the image properly

```
export PROJECT_ID="rhmap-docker"
export IMAGE_NAME="oracle-mbaas-service-node-4.4"
export IMAGE_VERSION="v1.0"
export CONTAINER_NAME="oracle-mbaas-service-rhmap-docker-dev"
```

## Build the image

```
docker build -t $PROJECT_ID/$IMAGE_NAME:$IMAGE_VERSION .
```

## Now let's run the image

As you can see below we're exposing port 8001 but you have to export the ports you need.

```
docker run -p=8001:8001 -it --rm -v $(pwd)/projects:/usr/projects --name $CONTAINER_NAME $PROJECT_ID/$IMAGE_NAME:$IMAGE_VERSION /bin/bash
```

## Example: running a cloud app and a service locally
Running locally a Cloud App that in its turn call a service also running locally.

### Run the container exposing 8001

```
docker run -p=8001:8001 -it --rm -v $(pwd)/projects:/usr/projects --name $CONTAINER_NAME $PROJECT_ID/$IMAGE_NAME:$IMAGE_VERSION /bin/bash
```

### Running the service in background

Clone both repos and run ``npm install`` (Cloud App and Service) then change dir to the service folder and run.

```
$ nohup grunt serve &
```

Now move to the cloud app folder and run

```
$ grunt serve:local
```

Finally use Postman, for instance, to call you cloud app running on port 8001 on your localhost.

### Stop all and exit
Type Ctrl+C and exit