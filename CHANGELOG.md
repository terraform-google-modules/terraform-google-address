# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [3.0.0](https://www.github.com/terraform-google-modules/terraform-google-address/compare/v2.1.1...v3.0.0) (2021-04-12)


### ⚠ BREAKING CHANGES

* add Terraform 0.13 constraint and module attribution

### Features

* Add support for setting purpose, network_tier, prefix_length, and ip_version ([#29](https://www.github.com/terraform-google-modules/terraform-google-address/issues/29)) ([451c131](https://www.github.com/terraform-google-modules/terraform-google-address/commit/451c131105c2313e47ce5e01fcfdfc153b7dd21b))
* add Terraform 0.13 constraint and module attribution ([88a65ae](https://www.github.com/terraform-google-modules/terraform-google-address/commit/88a65ae7d754d3aca387eb06df825482eb4cfd18))

### [2.1.1](https://www.github.com/terraform-google-modules/terraform-google-address/compare/v2.1.0...v2.1.1) (2021-02-03)


### Bug Fixes

* Remove symlinks in test fixtures ([#22](https://www.github.com/terraform-google-modules/terraform-google-address/issues/22)) ([912b479](https://www.github.com/terraform-google-modules/terraform-google-address/commit/912b479958a62558f9c6e33623dd6dca1c30ed3c))

## [2.1.0](https://www.github.com/terraform-google-modules/terraform-google-address/compare/v2.0.0...v2.1.0) (2020-06-01)


### Features

* Add self_links output ([#13](https://www.github.com/terraform-google-modules/terraform-google-address/issues/13)) ([43dfef4](https://www.github.com/terraform-google-modules/terraform-google-address/commit/43dfef4baa47d376e6e23d37a5f12d29f2fc5c27))

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
