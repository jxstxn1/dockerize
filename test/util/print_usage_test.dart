import 'package:dockerize_sidekick_plugin/src/util/print_usage.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Should return the correct usage of dockerize as String with the right cli name',
    () {
      expect(
          printUsage('testName'),
          '\nUsage: You can execute the following commands:\n'
          '• testName docker\n'
          '   • build\t\t Builds your project and the docker container\n'
          '      --docker-only\t Builds only the Docker Container\n'
          '      --env\t Choose between the existing environments\n'
          '   • run\t\t Runs the Docker Container on localhost:8000\n'
          '      -b, --build-all\t Builds the Flutter Web App and the Container before running\n'
          '      --build-docker\t Builds only the Docker Container before running\n'
          '      -p, --port\t Set a custom entry port for the container\n'
          '      --env\t Choose between the existing environments\n'
          '   • stop\t\t Stops the currently running docker container\n');
    },
  );
}