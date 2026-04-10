# [1.1.0](https://github.com/Finallf/terraria/compare/v1.0.0...v1.1.0) (2026-04-10)


### Features

* add item removal support to STARTINGINVENTORY ([ebe9a93](https://github.com/Finallf/terraria/commit/ebe9a93ab1a44f01b24b000b9df6207074097889))

# Changelog

All notable changes to the Terraria Server Docker project will be documented in this file.  
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-04-10
### Added
- Implemented full CI/CD pipeline via GitHub Actions.
- Added support for Conventional Commits and automatic semantic versioning.
- Automated image push to Docker Hub and GitHub Container Registry (GHCR).
- Automated contributor list updates in README.
- Configured `semantic-release` for automated release management.

---

## 📜 Legacy History (Pre-Automation)

This section records improvements implemented before the migration to the current CI/CD system.


### [v3.2.1] - 2026-04-09
- **Fixed:** The issue of duplicate items in sscconfig.json has been resolved.
- **Added:** Using GitHub Actions

### [v3.2] - 2026-03-24
- **Highlight:** Migration to TShock 6.1 for Terraria 1.4.5.6.
- **Fixed:** [Ex: UID/GID permission issues in the container]
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
