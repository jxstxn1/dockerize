// Function to replace the template dependencies with the installed dependencies
List<String> replaceTemplateDependencies(
  List<String> content,
  String packageName,
) {
  return content
      .map(
        (element) => element.replaceAll(
          '<<packageName>>',
          '${packageName}_sidekick',
        ),
      )
      .toList()
    ..removeWhere(
      (element) =>
          element.contains('//template import') ||
          element.contains('// template import') ||
          element.contains('installed import'),
    );
}
