# dockerize_sidekick_plugin sidekick plugin

A plugin for [sidekick CLIs](https://pub.dev/packages/sidekick).  
Generated from template `shared-code`.

## Description

This plugin for [sidekick](https://pub.dev/packages/sidekick) wants to make it as easy as possible to deploy your flutter web app as a docker container.

## Installation

### Prerequisites

- install `sidekick`: `dart pub global activate sidekick`
- generate custom sidekick CLI: `sidekick init`

Installing plugins to a custom sidekick CLI is very similar to installing a package with
the [pub tool](https://dart.dev/tools/pub/cmd/pub-global#activating-a-package).

### Installing dockerize as a sidekick plugin

## Run locally

Install the locally cloned plugin:

```bash
TODO: Change this after release
your_custom_sidekick_cli sidekick plugins install --source path path-to-local-dockerize-plugin
```

Run the dockerize command:

```bash
office dockerize
```

Start a container:

```bash
docker run -d --rm -p 8000:8080 --name main_package_name main_package_name:dev
```

Stop the container

```bash
docker kill main_package_name 
```

This will run your app and makes it accessible on port 8000. The full URL is <http://0.0.0.0:8000/#/>

## License

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
