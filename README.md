# dockerize_sidekick_plugin sidekick plugin

A plugin for [sidekick CLIs](https://pub.dev/packages/sidekick).  

## Description

This plugin for [sidekick](https://pub.dev/packages/sidekick) wants to make it as easy as possible to deploy your flutter web app as a docker container.

## Installation

### Kickstart

with having [docker](https://www.docker.com/) and [sidekick](https://pub.dev/packages/sidekick) installed

```bash
<<your_cli>> sidekick plugins install dockerize_sidekick_plugin
<<your_cli>> docker run -b
```

### Docker

To run this locally you need [Docker](https://docs.docker.com/get-docker/) installed on your machine.

### The commands

#### Install the plugin

```bash
<<your_cli>> sidekick plugins install dockerize_sidekick_plugin
```

#### Build the docker image

```bash
<<your_cli>> docker build
```

You can customize the build process in the commands/docker/build_command.dart file.

#### Run the docker image locally

```bash
<<your_cli>> docker run
```

This will run your app and makes it accessible at `localhost:8000`.
With the `--background` flag you can run the container in the background.
With the `-b, --build` flag you can execute the build command before running the container.
With the `-p, --port` flag you can specify the port on which the app is accessible.

You can detach from your running container with `Ctrl + P + Q` or `Ctrl + C`.
Afterwards you can kill the container with `<<your_cli>> docker stop`.

#### Stop the container

```bash
<<your_cli>> docker stop
```

### Help

If you need help, you can always use the help command.

```bash
<<your_cli>> docker --help
```

### Issues and Feedback

Feel free to open an issue or send a pull request.

### License

   ```Text
   Copyright 2022 Justin Baumann, Robin Schönau

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
