# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [v2.0.0](https://github.com/terraform-google-modules/terraform-google-address/releases/tag/v2.0.0) 2019-10-16

### Changed

- The supported version of Terraform is 0.12. [#10]

## [v1.0.0](https://github.com/terraform-google-modules/terraform-google-address/releases/tag/v1.0.0) 2019-06-08

### Added
- Added support for setting `region`. [#8](https://github.com/terraform-google-modules/terraform-google-address/pull/8)

## [v0.2.0](https://github.com/terraform-google-modules/terraform-google-address/releases/tag/v0.2.0) 2019-06-04

### Added
- Added support for setting `project_id`. [#7](https://github.com/terraform-google-modules/terraform-google-address/pull/7)

## [v0.1.0](https://github.com/terraform-google-modules/terraform-google-address/releases/tag/v0.1.0) 2019-01-18

### Added
- This is the initial release of the module with basic support for:
    - Reserving internal/external IP addresses
        - Optionally, being able to reserve specific IP addresses within a subnetwork (internal IP addresses only)
    - Registering IP addresses with Google Cloud DNS
        - Forward and Reverse lookup zones are supported

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-address/compare/v2.0.0...HEAD
[#10]: https://github.com/terraform-google-modules/terraform-google-address/pull/10
