/// Prints the Usage of the dockerize Sidekick Plugin
String printUsage(String cliName) {
  return '''
Usage: $cliName docker [command] [flags]

Commands:
  build [app|scripts|image]  Build the Docker image or run specific build commands
  stop                       Stop the Docker container
  run                        Runs the Docker image locally

Flags:
  -h, --help                 Show this message
  -b, --build-all            Execute all build commands before running the container
  --build-scripts            Execute the scripts build command before running the container
  --build-image              Execute the image build command before running the container
  -p, --port                 Specify the port on which the app is accessible
  --env                      Specify the environment to use (default is "dev")
''';
}
