// ignore: avoid_classes_with_only_static_members
/// A set of environments that are used to configure Dockerize.
/// You can add more environments here if you need to.
class DockerizeEnvironments {
  static Set<DockerizeEnvironment> get all => _all.toSet();
  static const List<DockerizeEnvironment> _all = [
    dev,
    preprod,
    prod,
  ];

  static const DockerizeEnvironment dev = DockerizeEnvironment('dev');
  static const DockerizeEnvironment preprod = DockerizeEnvironment('preprod');
  static const DockerizeEnvironment prod = DockerizeEnvironment(
    'prod',
    shouldEnforceCSP: true,
  );
}

/// A DockerizeEnvironment is a set of configuration values that are specific to a given environment.
/// For example, the dev environment might have a different API endpoint than the prod environment.
/// The environment contains different properties that are used to configure Dockerize.
/// You can also insert values here for your flutter web app which are defined via dart_defines.
class DockerizeEnvironment {
  const DockerizeEnvironment(this.name, {this.shouldEnforceCSP = false});

  /// The name of the environment.
  final String name;

  /// Whether or not to report-only Content Security Policy violations.
  final bool shouldEnforceCSP;

  @override
  String toString() =>
      'Environment{name: $name, shouldEnforceCSP: $shouldEnforceCSP}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DockerizeEnvironment &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          shouldEnforceCSP == other.shouldEnforceCSP;

  @override
  int get hashCode => name.hashCode ^ shouldEnforceCSP.hashCode;
}
