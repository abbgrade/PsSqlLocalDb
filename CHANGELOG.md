# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2022-09-30

### Added

- Added `Get-Version` command.

### Changed

- Type of instance.Version was changed from string to System.Version.
- Added parameter validation of version for `New-Instance`.

## [0.2.0] - 2022-03-27

### Added

- New-Instance command.
- Remove-Instance command.
- Stop-Instance command.

### Fixed

- Empty version for Get-Instance.
- Multiple results for Get-Instance.

## [0.1.0] - 2022-03-15

### Added

- Get-Instance command.
- Test-Utility command.

<!-- markdownlint-configure-file {"MD024": { "siblings_only": true } } -->
