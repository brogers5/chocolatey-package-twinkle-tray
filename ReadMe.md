# <img src="https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-twinkle-tray@800782d6afb5b6ab2e4dcefdb879bea194f0fef8/twinkle-tray.png" width="48" height="48"/> Chocolatey Package: [Twinkle Tray](https://community.chocolatey.org/packages/twinkle-tray)

[![Chocolatey package version](https://img.shields.io/chocolatey/v/twinkle-tray.svg)](https://community.chocolatey.org/packages/twinkle-tray)
[![Chocolatey package download count](https://img.shields.io/chocolatey/dt/twinkle-tray.svg)](https://community.chocolatey.org/packages/twinkle-tray)

## Install

[Install Chocolatey](https://chocolatey.org/install), and run the following command to install the latest approved version from the Chocolatey Community Repository:

```shell
choco install twinkle-tray --source="'https://community.chocolatey.org/api/v2'"
```

Alternatively, the packages as published on the Chocolatey Community Repository will also be mirrored on this repository's [Releases page](https://github.com/brogers5/chocolatey-package-twinkle-tray/releases). The `nupkg` can be installed from the current directory as follows:

```shell
choco install twinkle-tray --source="'.'"
```

## Build

[Install Chocolatey](https://chocolatey.org/install), the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au), and the [PowerShellForGitHub PowerShell Module](https://github.com/microsoft/PowerShellForGitHub), then clone this repository.

Once cloned, simply run `build.ps1`. The binary is intentionally untracked to avoid bloating the repository, so the script will download the Twinkle Tray installer binary from the official distribution point, then packs everything together.

A successful build will create `twinkle-tray.x.y.z.nupkg`, where `x.y.z` should be the Nuspec's `version` value at build time.

Note that Chocolatey package builds are non-deterministic. Consequently, an independently built package will fail a checksum validation against officially published packages.

## Update

This package should be automatically updated by the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au). If it is outdated by more than a few days, please [open an issue](https://github.com/brogers5/chocolatey-package-twinkle-tray/issues).

AU expects the parent directory that contains this repository to share a name with the Nuspec (`twinkle-tray`). Your local repository should therefore be cloned accordingly:

```shell
git clone git@github.com:brogers5/chocolatey-package-twinkle-tray.git twinkle-tray
```

Alternatively, a junction point can be created that points to the local repository (preferably within a repository adopting the [AU packages template](https://github.com/majkinetor/au-packages-template)):

```shell
mklink /J twinkle-tray ..\chocolatey-package-twinkle-tray
```

Once created, simply run `update.ps1` from within the created directory/junction point. Assuming all goes well, all relevant files should change to reflect the latest version available. This will also build a new package version using the modified files.

Before submitting a pull request, please [test the package](https://docs.chocolatey.org/en-us/community-repository/moderation/package-verifier#steps-for-each-package) using the [Chocolatey Testing Environment](https://github.com/chocolatey-community/chocolatey-test-environment) first.
