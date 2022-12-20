# Server Folder

This folder contains the server code for the project.
It contains the following files:

- `bin/server.dart` - The main entry point for the server.
- `bin/middlewares.dart` - Contains all the middlewares for the server. Contains all CSP, CORS, and other security headers.
- `Dockerfile` - The Dockerfile to build a docker image containing the server

## Running the server

The recommended way to run the server is to run it within docker with the following command:

```bash
<<cli_name>> docker run -b
```

If you nevertheless want to run the server locally, you can do so by using the following command from your repo root:

```bash
<<cli_name>> docker build
dart run -Druns-locally=true server/bin/server.dart 
```
