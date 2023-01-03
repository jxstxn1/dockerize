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
