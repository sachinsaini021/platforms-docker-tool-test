#!/bin/bash

#Given mock API
App_json=`curl http://localhost:6161/api/applications/conversation-app` 

Response_file="Response.txt" #Response file for output

# Validation if correct json response is returned.

ValidateJson(){
if jq -e . >/dev/null 2>&1 <<<"$1"; then
    echo "Its a Json! "
    return 0
else
    echo "Failed to parse JSON,Please check the response"
    exit 1
fi
}

ValidateValues(){
    if [ -z $2 ];
    then
    echo "Value of $1 is null.Exiting"
    exit 1
    fi
}

#Validate the Json response
ValidateJson "${App_json}"

#Extract Values and Validate
image=`echo "${App_json}" | jq -r .image`
ValidateValues image "$image"

endpoint=`echo "${App_json}" | jq -r .endpoint`
ValidateValues endpoint "$endpoint"

hostPort=`echo "${App_json}" | jq -r .config.ports[0].hostPort`
ValidateValues hostPort "$hostPort"

containerPort=`echo "${App_json}" | jq  -r .config.ports[0].containerPort`
ValidateValues containerPort "$containerPort"

environment=`echo "${App_json}" | jq -r .config.environment.SAY_HELLO_TO`
ValidateValues environment "$environment"

#Run Docker Container
#docker run -dit -p ${hostPort}:${containerPort} -e "SAY_HELLO_TO=${environment}" ${image}

#Health Check Docker container with 1 minute timeout
max_iterations=12
wait_seconds=5
http_endpoint="http://localhost:${hostPort}/health"

iterations=0
while true
do
	((iterations++))
	echo "Health Check $iterations for Docker Container"
	sleep $wait_seconds

	http_code=$(curl -s -o /dev/null -w '%{http_code}' "$http_endpoint";)

	if [ "$http_code" -eq 200 ]; then
		echo "Container is Up"
		break
	fi

	if [ "$iterations" -ge "$max_iterations" ]; then
		echo "Container did not start in specified time"
		exit 1
	fi
done

Response=$(curl "http://localhost:${hostPort}${endpoint}")

ValidateJson "${Response}"

echo "${Response}"  | jq -r .message > ${Response_file}