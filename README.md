# COSMOS — Developer Workstation Provisioning

Automation framework for provisioning developer workstations (Windows ARM64 / macOS ARM64) via a custom YAML-based task runner.

---

## Overview

COSMOS automates the full installation and configuration of the developer toolchain required for the Calypso project. It handles binary distribution, tool installation, environment configuration, and cleanup — all in a repeatable, silent deployment.

---

## Requirements

| Platform | Architecture | Notes                    |
| -------- | ------------ | ------------------------ |
| Windows  | ARM64        | Primary target           |
| macOS    | ARM64        | Supported for some tools |

A local binary server must be reachable at `http://192.168.64.2:8080/` to serve installation files.

---

## File Structure

```
main.yml              # Entry point — downloads binaries and runs all install tasks
prepare_env.yml       # Legacy bootstrap (Windows only, network share based)
install_java.yml      # OpenJDK 21 installation
install_intellij.yml  # IntelliJ IDEA Community + NPKM/Nuke plugins
install_vscode.yml    # Visual Studio Code
install_dbeaver.yml   # DBeaver CE
install_path.yml      # npkm-coni and nuke CLI tools
set_nexus.yml         # Maven settings.xml → Nexus proxy
clean.yml             # Full uninstallation / reset
```

---

## What Gets Installed

| Tool                    | Version                         | Platform        |
| ----------------------- | ------------------------------- | --------------- |
| OpenJDK                 | 21                              | Windows / macOS |
| IntelliJ IDEA Community | 2026.1.1 (Win) / 2026.1.2 (Mac) | Windows / macOS |
| NPKM plugin             | 1.0.0                           | Windows / macOS |
| Nuke plugin             | 1.0.0                           | Windows / macOS |
| Visual Studio Code      | 1.120.0                         | Windows         |
| DBeaver CE              | 26.0.5                          | Windows         |
| npkm-coni CLI           | latest                          | Windows         |
| nuke CLI                | latest                          | Windows         |

---

## Usage

### Full provisioning

Run `main.yml` to download all binaries and execute all install tasks in order:

```
install_path → install_java → install_intellij → install_vscode → install_dbeaver
```

Nexus configuration is handled separately via `set_nexus.yml`.

### Individual tasks

Each `install_*.yml` file can be run independently.

### Clean / reset

`clean.yml` removes all installed tools, PATH entries, and configuration files:

- Java (`C:\Program Files\Java`)
- IntelliJ (`C:\Program Files\JetBrains`, AppData)
- VS Code (`C:\Program Files\Microsoft VS Code`, AppData)
- DBeaver (`C:\Program Files\DBeaver`, AppData)
- npkm / nuke
- Maven `settings.xml`
- Desktop shortcuts
- `C:\Temp`

---

## Nexus Configuration

`set_nexus.yml` writes `%USERPROFILE%\.m2\settings.xml` pointing all Maven requests to the internal Nexus proxy:

```
http://10.101.2.216:8081/repository/maven-public/
```

The mirror covers all repositories (`mirrorOf: *`) and enables both releases and snapshots.

---

## Desktop Shortcuts

The following shortcuts are created in `C:\Users\Public\Desktop\` (visible to all users):

- `IntelliJ IDEA.lnk`
- `Visual Studio Code.lnk`

`clean.yml` removes both.

---

## Notes

- All installs are **silent** (no user interaction required).
- `when: ansible_os_family == 'Windows'` guards ensure tasks only run on the correct platform.
- Binary downloads use a temp folder (`C:\Temp` on Windows, `/private/tmp/npkm-install` on macOS) that is cleaned up post-install.
- `prepare_env.yml` is a legacy bootstrap using a network share (`\\192.168.100.15\share\npkm\binaries`) — superseded by `main.yml`.
