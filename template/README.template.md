# Server Folder

This folder contains the server code for the project.
It contains the following files:

- `bin/server.dart` - The main entry point for the server.
- `bin/middlewares.dart` - Contains all the middlewares for the server. Contains all CSP, CORS, and other security headers.
- `Dockerfile` - The Dockerfile for the server to build it.

## Running the server

The recommended way to run the server is to use the Dockerfile by using the following command:

```bash
<<cli_name>> docker run -b
```

To run the server you can use the following command from your repo root:

```bash
dart run -Druns-locally=true server/bin/server.dart 
```
