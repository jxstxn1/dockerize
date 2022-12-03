#!/usr/bin/env bash
set -e

echo "Generating Sidekick Template Bundle"
rm -rf lib/src/templates/
true | dart run tool/local_mason.dart bundle template/dockerize_template -t dart -o lib/src/templates/
mv lib/src/templates/dockerize_template_bundle.dart lib/src/templates/dockerize_template_bundle.g.dart
dart format lib/src/templates/*.g.dart