# dockerize_sidekick_plugin sidekick plugin

A plugin for [sidekick CLIs](https://pub.dev/packages/sidekick).  

## Description

This plugin for [sidekick](https://pub.dev/packages/sidekick) wants to make it as easy as possible to deploy your flutter web app as a docker container.

## Installation

### Prerequisites

- install `sidekick`: `dart pub global activate sidekick`
- generate custom sidekick CLI: `sidekick init`

Installing plugins to a custom sidekick CLI is very similar to installing a package with
the [pub tool](https://dart.dev/tools/pub/cmd/pub-global#activating-a-package).

### Installing dockerize as a sidekick plugin

```bash
<cli> sidekick plugins install dockerize_sidekick_plugin
```

### Building the Web App and the Container

```bash
<cli> docker build
```

You can customize the build process in the commands/docker/build_command.dart file.

### Run the Container

```bash
<cli> docker run
```

This will run your app and makes it accessible on port 8000. The full URL is <localhost:8000/#/>
With the -b, --build flag you can execute the build command before running the container.

### Stop the container

```bash
<cli> docker stop
```

### Help

If you need help, you can always use the help command.

```bash
<cli> docker --help
```

### Issues and Feedback

Feel free to open an issue or send a pull request.

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
