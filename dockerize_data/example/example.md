# Example

You can use dockerize_data like this:

```dart
 void main () {
    final dockerize = DockerizeData.instance;
    dockerize.cspHashes = ['sha256-1234567890'];
    dockerize.shouldEnforceCsp = true;
 }

 void secondClass () {
    final dockerize = DockerizeData.instance;
    print(dockerize.cspHashes); // ['sha256-1234567890']
    print(dockerize.shouldEnforceCsp); // true
 }
```
