/// Prints the Usage of the dockerize Sidekick Plugin
String printUsage(String cliName) {
  return '\nUsage: You can execute the following commands:\n'
      '• $cliName docker\n'
      '   • build\t\t Builds your project and the docker container\n'
      '   • run\t\t Runs the Docker Container on localhost:8000\n'
      '     -b, --build\t Calls the build command before running the app\n'
      '   • stop\t\t Stops the currently running docker container\n';
}
