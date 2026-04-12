# Changelog

All notable changes to the Terraria Server Docker project will be documented in this file.<br>
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).<br>

---
<br>


# [1.2.0-beta.4](https://github.com/Finallf/terraria/compare/v1.2.0-beta.3...v1.2.0-beta.4) (2026-04-12)


### Bug Fixes

* Testing changes in compose.yml ([b76da3d](https://github.com/Finallf/terraria/commit/b76da3dd20d79bf1598a55dc889ef3f83ed46fa0))

# [1.2.0-beta.3](https://github.com/Finallf/terraria/compare/v1.2.0-beta.2...v1.2.0-beta.3) (2026-04-12)


### Bug Fixes

* Fixed an error where AUTO_SAVE was not being applied. ([191c48f](https://github.com/Finallf/terraria/commit/191c48f84fc82325a54f9cf89eaecda9a39263bb))

# [1.2.0-beta.2](https://github.com/Finallf/terraria/compare/v1.2.0-beta.1...v1.2.0-beta.2) (2026-04-12)


### Bug Fixes

* Error with .releaserc when writing to the changelog. ([513c3e4](https://github.com/Finallf/terraria/commit/513c3e4dfa9aae74bd9412cbf61873a483536e8a))

# [1.2.0-beta.1](https://github.com/Finallf/terraria/compare/v1.1.0...v1.2.0-beta.1) (2026-04-12)

### Features

* add AUTO_SAVE environment variable control ([9939c31](https://github.com/Finallf/terraria/commit/9939c31500c0bb64bc7552342eff0858cc232688))

# [1.1.0](https://github.com/Finallf/terraria/compare/v1.0.0...v1.1.0) (2026-04-10)

### Features
* add item removal support to STARTINGINVENTORY ([ebe9a93](https://github.com/Finallf/terraria/commit/ebe9a93ab1a44f01b24b000b9df6207074097889))

## [1.0.0] - 2026-04-10
### Added
- Implemented full CI/CD pipeline via GitHub Actions.
- Added support for Conventional Commits and automatic semantic versioning.
- Automated image push to Docker Hub and GitHub Container Registry (GHCR).
- Automated contributor list updates in README.
- Configured `semantic-release` for automated release management.

<br>

---

# 📜 Legacy History (Pre-Automation)

This section records improvements implemented before the migration to the current CI/CD system.


### [v3.2.1] - 2026-04-09
- **Fixed:** The issue of duplicate items in sscconfig.json has been resolved.
- **Added:** Using GitHub Actions

### [v3.2] - 2026-03-24
- **Highlight:** Migration to TShock 6.1 for Terraria 1.4.5.6.
- **Fixed:** UID/GID permission issues in the container
- **Security:** Dynamic Configuration (changed to Inject items with JQ).
- **Added:** Option to enable container logging; the default is now disabled ( `LOG_INIT=true` ).
- **Added:** All documentation was created in Markdown.

### [v3.1] - 2026-03-15
- **Changed:** Optimized initialization arguments (`-nosplash`, `-lang`).
- **Added:** Support for external volumes (`/config`, `/crashes`, `/logs`, `/plugins`, `/world`).
- **Added:** Option to store REST API logs (`LOG_REST`).
- **Changed:** High-Precision Logs (With Timestamps and Error Capture).
- **Added:** Allow initial items, based on some listed items.

### [v3.0] - 2026-03-11
- **Highlight:** Migration to TShock 6 for Terraria 1.4.5.5.
- **Fixed:** Improved logic for "Graceful Shutdown".
- **Added:** Disable/Enable Login using UUID.
- **Added:** Disable/Enable SSC (Server Side Character).
- **Added:** Disable/Enable REST API.
- **Added:** Code cleanup and variable standardization.
- **Added:** Symbolic link to the ServerLog file in the logs folder.

### [v2.5] - 2026-03-10
- **Added:** Logging system created for the container.
- **Added:** Dynamic Inventory Injection (Via environment variable and seed).
- **Added:** Safe Shutdown (With signal traps to save the world).

### [v2.0] - 2026-03-08
- **Added:** First implementation of Logs.
- **Added:** Trap for SIGTERM.
- **Added:** Pipe creation (if [ ! -p ... ]).
- **Changed:** Server execution in background ( exec ... & ).
- **Changed:** Pipe monitor with Descriptor 3.
- **Added:** Wait for Process (wait $child).

---

## [v1.0] - 2026-03-07
- **Added:** First functional version of the Terraria/T-Shock container.
- **Added:** Multi-Stage Dockerization (Optimized and without Supervisor).
- **Added:** Network Health Check (Verifying port 7777).
