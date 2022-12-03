# dockerize_sidekick_plugin sidekick plugin

A plugin for [sidekick CLIs](https://pub.dev/packages/sidekick).  
Generated from template `shared-code`.

## Description

This plugin for [sidekick](https://pub.dev/packages/sidekick) wants to make it as easy as possible to deploy your flutter web app as a docker container.

## Installation

### Prerequisites:

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
docker run -it --rm -p 8000:8080 --name your_custom_sidekick_cli your_custom_sidekick_cli:dev
```
This will run your app and makes it accessible on port 8000. The full URL is http://0.0.0.0:8000/#/
