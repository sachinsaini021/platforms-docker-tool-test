# Rightmove Platforms Interview Exercise

## Outline

Build a tool which could be used as part of a CI (continuous integration) pipeline. This tool should download JSON, extract configuration items and start docker containers.

Write the tool as if both yourself and other developers would need to support it in future. You are free to use whatever tooling you think appropriate. Some examples might be:

- gradle plugin
- groovy
- python
- node
- go

Things we look for:

- Structured and clean code
- Separation of concerns
- Unit tests
- Integration tests

We don't expect the exercise to take more than 2 hours, however feel free to spend as long as you want on it so that you're happy with the result.

Normally a developer would be expected to collaborate with users of the tool, however, since that isn't feasible for this exercise, feel free to make assumptions; document what and why in a README or alongside your code.

Feel free to use third party tools / libraries if you think they fit the use case (e.g. a Docker client for the language you decide to write your tool with).  Be prepared to justify your decisions.

## Requirements

You will need to install docker and docker-compose (if you haven't already) for this exercise. 

Docker: https://docs.docker.com/engine/install/

Docker Compose: https://docs.docker.com/compose/install/ 

# Setup

To build the test images which are used for this exercise, run the following docker commands from the root of this project:

```
docker build -t conversation/say-hello images/say-hello
docker build -t conversation/say-goodbye images/say-goodbye
```

## Specification

The tool you will build should:

- Download JSON from an API via HTTP request;
    - A mock API has been provided for this exercise. See *Running the application configuration mock API* for details, where you will also find the documentation for this API.
    - The API endpoint you will need to query is `GET http://localhost:6161/api/applications/conversation-app`
    - The JSON response represents the configuration for one app, the conversation app, which starts a single container from the image `conversation/say-hello`.
- Process this JSON and start the container (and wait for it to become healthy).
- Once the container is healthy, hit the endpoint which is returned as part of the JSON and write the `message` field of the response to a file. 

For example, given JSON that looks like this:
 
 ```json
{
  "image": "conversation/say-cheers",
  "endpoint": "/say-cheers",
  "config": {
    "ports": [
      {
        "hostPort": 9767,
        "containerPort": 8080
      }
    ],
    "environment": {
      "SAY_CHEERS_TO": "World"
    }
  }
}
```

A container should be started (and checked if healthy) and then the `/say-cheers` endpoint should be hit. The response might look something like:

```json
{
    "message": "Cheers World"
}
```

We expect your tool will then generate a file with the contents:

```
Cheers World
```

## Running the application configuration mock API

We've provided a mock API for this exercise called the "application configuration API".  It uses Wiremock to create a simple server that returns JSON 
and contains a single endpoint which returns the configuration for a single application (conversation-app).

Run it with the following commands:

```
docker-compose up --build -d
```

To see the JSON, query `http://localhost:6161/api/applications/conversation-app`.

To stop the server run:

```bash
docker-compose down
```

Below is some documentation for an example response:

```
{   
  # this is the image name
  "image": "conversation/say-cheers",

  # endpoint path which must be hit with GET request after container has started
  "endpoint": "/say-cheers"

  # configuration for the container
  "config": {

    # list of port mapping objects containing the host port and container port which will map to each other
    "ports": [
      {
        "hostPort": 9767,
        "containerPort": 8080
      }
    ],

    # an map containing KEY:VALUE pairs of environment variables that need to be set when starting the container
    "environment": {
        "SAY_HELLO_TO": "World"
    }

  }
}
```

## Submission

The test submission needs to be archived (e.g. zip or tar) and sent via a file sharing site to ensure your submission is not blocked.

We recommend using https://wetransfer.com/ - Please fill in the information required, the 'email to' should be: platformstests@rightmove.co.uk. If you have any issues sending us your archive, try submitting a file sharing link such as Dropbox, or send us an email to discuss further options.

If we need any build tools or runtime environments to execute the code you submit, please describe how to install them in a readme file within the submitted archive.