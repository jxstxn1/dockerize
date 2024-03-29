## 0.9.0

- **Breaking: You have to reinstall dockerize_sidekick_plugin to use this version.**
- Using dockerize_data as data container

## 0.8.0

- **Breaking: You have to reinstall dockerize_sidekick_plugin to use this version.**
- Migrate Server folder to Dart >3.0.0
- Use newest helmet version
- Go back to build

## 0.7.0

- Upgrade to Dart 3.0.0

## 0.6.0

- **Breaking: You have to reinstall dockerize_sidekick_plugin to use this version.**
- Environments are now abstract
- run will automatically call build
- removed build_scripts command
- Solved the issue that every build changes your git diff
- add dockerize_registrant
- handle handles all requests

## 0.5.0

- Add dockerize_data

## 0.4.0

- **Breaking: You have to reinstall dockerize_sidekick_plugin to use this version.**
- Refactored server folder
- Allow injecting docker build arguments by @passsy
- Check if docker engine is running by @passsy

## 0.3.2

- Fix: Automatically ignored build-folder

## 0.3.1

- Fix: .gitignore install error

## 0.3.0

- **Breaking: You have to reinstall dockerize_sidekick_plugin to use this version.**
- BuildCommand
  - Use dockerx for builds
  - Improved Build Output
  - Add build information to version file
- Run Command
  - Kill with ctrl c once
  - Hot rebuild
- General:
  - Add www Folder to .gitignore* Remove dcli
  - Use Sidekick Core 1.0.0
  - Add Docker Garbage Collector

## 0.2.1

- Fixed a bug where the CSP Rules where enforced instead of reportOnly
  - You can regenerate dockerize_sidekick_plugin with the new version to fix this.
    or you can change in `middlewares.dart` the following line: `reportOnly: shouldEnforceCsp,` to `reportOnly: !shouldEnforceCsp,`

## 0.2.0

- **Breaking: You have to reinstall dockerize_sidekick_plugin to use this version.**
- Improved Documentation
- Run in foreground
- Set CSP to reportOnly
- Auto generate Hashes for scripts in index.html
- Be able to use other ports
- Add readme to server
- Add environment
- Kill container on Ctrl+C

## 0.1.0

- MVP Release.
