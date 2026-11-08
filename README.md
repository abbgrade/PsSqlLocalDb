# PsSqlLocalDb

[![.github/workflows/build-validation.yml](https://github.com/abbgrade/PsSqlLocalDb/actions/workflows/build-validation.yml/badge.svg)](https://github.com/abbgrade/PsSqlLocalDb/actions/workflows/build-validation.yml)

PsSqlLocalDb is a PowerShell module for managing SQL Server LocalDB instances
through the [SqlLocalDB utility](https://learn.microsoft.com/sql/tools/sqllocaldb-utility).
It was developed to integrate LocalDB into PowerShell-based DevOps workflows,
including automated testing.

## Features

- List installed SQL Server LocalDB versions and instances.
- Create and start LocalDB instances.
- Stop and remove instances.
- Check whether the SqlLocalDB utility is available.

## Requirements

- Windows with SQL Server LocalDB installed.
- PowerShell 7.2 or later.

## Installation

The module is available from the [PowerShell Gallery](https://www.powershellgallery.com/packages/PsSqlLocalDb):

```powershell
Install-Module -Name PsSqlLocalDb
```

To build and install from source, clone the repository, install
[InvokeBuild](https://github.com/nightroman/Invoke-Build) and
[platyPS](https://www.powershellgallery.com/packages/platyPS), then run:

```powershell
Invoke-Build Install
```

## Usage

Import the module and check the installed LocalDB versions and instances:

```powershell
Import-Module PsSqlLocalDb
Get-LocalDbVersion
Get-LocalDbInstance
```

Create and start a temporary instance, inspect its connection details, then
remove it when finished:

```powershell
$instance = New-LocalDbInstance -Name 'PsSqlLocalDbQuickStart'
Get-LocalDbInstance -Name $instance.Name

# Use $instance.NamedPipe to connect to the LocalDB instance.

Remove-LocalDbInstance -Name $instance.Name
```

See the [command reference](https://abbgrade.github.io/PsSqlLocalDb/) for all
commands, parameters, and examples.

## Changelog

See [CHANGELOG.md](./CHANGELOG.md).

## Development

- This is a [Portable Module](https://docs.microsoft.com/de-de/powershell/scripting/dev-cross-plat/writing-portable-modules?view=powershell-7).
- [VSCode](https://code.visualstudio.com) is recommended as IDE. [VSCode Tasks](https://code.visualstudio.com/docs/editor/tasks) are configured.
- Build automation is based on [InvokeBuild](https://github.com/nightroman/Invoke-Build)
- Test automation is based on [Pester](https://pester.dev)
- Commands are named based on [Approved Verbs for PowerShell Commands](https://docs.microsoft.com/de-de/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands)
- This project uses [git-flow](https://github.com/nvie/gitflow).
- This project uses [keep a changelog](https://keepachangelog.com/en/1.0.0/).

### Build

The build scripts require InvokeBuild and platyPS. Install them with
`Install-Module InvokeBuild, platyPS -Scope CurrentUser`.

You can build the module using the VS Code build task or with the command `Invoke-Build Build`.

### Release

1. Create a release branch using git-flow.
2. Update the version number in the module manifest.
3. Extend the changelog in `CHANGELOG.md`.
4. If you want to create a pre-release.
   1. Push the release branch to GitHub, to publish the pre-release to PsGallery.
5. Finish release using git-flow.
6. Verify that the release tag has been pushed to GitHub; push it if needed.
7. Check if the release branch is deleted on GitHub.
8. Create the release on GitHub.
