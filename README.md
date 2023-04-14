# dockerize_sidekick_plugin

[![codecov](https://codecov.io/gh/jxstxn1/dockerize_sidekick_plugin/branch/main/graph/badge.svg?token=PXZ5RFYXCL)](https://codecov.io/gh/jxstxn1/dockerize_sidekick_plugin)
[![License: Apache2](https://img.shields.io/badge/license-Apache2.0-purple.svg)](https://opensource.org/licenses/Apache-2.0)

A plugin for [sidekick CLIs](https://pub.dev/packages/sidekick).  

## Description

This plugin for [sidekick](https://pub.dev/packages/sidekick) wants to make it as easy as possible to deploy your flutter web app as a docker container.

## Installation

### Kickstart

with having [docker](https://www.docker.com/) and [sidekick](https://pub.dev/packages/sidekick) installed

```bash
<<your_cli>> sidekick plugins install dockerize_sidekick_plugin
<<your_cli>> docker run
```

### Docker

To run this locally you need [Docker](https://docs.docker.com/get-docker/) installed on your machine.

### The commands

#### Install the plugin

```bash
<<your_cli>> sidekick plugins install dockerize_sidekick_plugin
```

#### Build the Docker Image

There are multiple build commands available for this plugin. Here is a brief overview:

- `<<your_cli>> docker build app`: Runs a basic Flutter build web command
- `<<your_cli>> docker build image`: Builds the Docker image and also executes the app
You can choose between different environments using the --env flag. The default environment is dev. You can customize the build process in the commands/build folder.

#### Run the Docker Image Locally

To run the Docker image locally, use the following command:

```bash
<<your_cli>> docker run
```

This will run the app and make it accessible at `localhost:8000`.

Notice:
A hot-reload is enabled, which will rerun the required build commands if you change a file. You can detach and kill the container by pressing `Ctrl + C`.

- `-p, --port`: Specifies the port on which the app is accessible.
The build command can choose between different environments. The default environment is `dev`. You can change the environment with the `--env` flag.

#### Stop the container

```bash
<<your_cli>> docker stop
```

#### Deploy the docker image

Deploying the docker image depends on the environment you are deploying to.
Here are the official guides for the biggest cloud providers:

- [AWS](https://aws.amazon.com/getting-started/hands-on/deploy-docker-containers/)
- [Azure](https://docs.docker.com/cloud/aci-integration/)
- [Google Cloud Run](https://cloud.google.com/run/docs/quickstarts/deploy-container)

### Further reading

#### Environments

By default we are generating a very simple way of handling different environments.
You can change the environments in the `commands/docker/environment.dart` file.

#### Build args

You can easily pass arguments to your docker file.
To do this you can just pass the build args into the `createDockerImage` function in the `commands/docker/build_image_command.dart` file.

#### Script hashes

By default we are generating script hashes for each script tag in your index.html file.
You can change the hashtype or disable it in the `commands/docker/build_command.dart` file.

#### CSP Rules

By default we are adding a default Set of CSP rules to the `server/bin/middlewares.dart` File.
You can change the rules or disable them in the `commands/docker/build_command.dart` file.
You can find more informations about CSP Rules [here](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP).

#### Docker Garbage Collection

We are currently collecting all dangling images and containers after the build process to keep your docker environment clean.
If you dont want to have this Feature feel free to open an Issue.

### Help

If you need help, you can always use the help command.

```bash
<<your_cli>> docker --help
```

### Issues and Feedback

Feel free to open an issue or send a pull request.

### License

   ```Text
   Copyright 2023 Justin Baumann, Robin Schönau

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
   ```
