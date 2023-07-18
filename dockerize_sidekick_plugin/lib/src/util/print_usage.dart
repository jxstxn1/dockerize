/// Prints the Usage of the dockerize Sidekick Plugin
String printUsage(String cliName) {
  return '''
Usage: $cliName docker [command] [flags]

Commands:
  build [app|image]  Build the Docker image or the app
  stop                       Stop the Docker container
  run                        Runs the Docker image locally

Flags:
  -h, --help                 Show this message
  --build-image              Execute the image build command before running the container
  --without-hot-reload       Run the app without hot reload
  -p, --port                 Specify the port on which the app is accessible
  --env                      Specify the environment to use (default is "dev")
''';
}
