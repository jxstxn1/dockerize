class DockerizeData {
  DockerizeData._();

  static final DockerizeData _instance = DockerizeData._();

  static DockerizeData get instance => _instance;

  bool shouldEnforceCsp = false;
  List<String> cspHashes = [];
}
