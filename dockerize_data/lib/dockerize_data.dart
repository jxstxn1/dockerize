/// Library which is containing the source code for the dockerize data package
library dockerize_data;

class DockerizeData {
  DockerizeData._();

  static final DockerizeData _instance = DockerizeData._();

  static DockerizeData get instance => _instance;

  bool shouldEnforceCsp = false;
  List<String> cspHashes = [];
}
