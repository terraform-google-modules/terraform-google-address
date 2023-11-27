# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [3.2.0](https://github.com/terraform-google-modules/terraform-google-address/compare/v3.1.3...v3.2.0) (2023-11-27)


### Features

* upgraded versions.tf to include minor bumps from tpg v5 ([2465280](https://github.com/terraform-google-modules/terraform-google-address/commit/2465280c8763b98f40c892505194b30e4c64c105))

## [3.1.3](https://github.com/terraform-google-modules/terraform-google-address/compare/v3.1.2...v3.1.3) (2023-06-15)


### Bug Fixes

* fixes for tflint ([#89](https://github.com/terraform-google-modules/terraform-google-address/issues/89)) ([76f0701](https://github.com/terraform-google-modules/terraform-google-address/commit/76f07016b0c95cadc01912decf210b4ec94ba69e))

## [3.1.2](https://github.com/terraform-google-modules/terraform-google-address/compare/v3.1.1...v3.1.2) (2022-11-03)


### Bug Fixes

* maps one ip to multiple dns records ([#59](https://github.com/terraform-google-modules/terraform-google-address/issues/59)) ([6085d28](https://github.com/terraform-google-modules/terraform-google-address/commit/6085d282a74c8b918f6f08b30224e064955b3384))

### [3.1.1](https://github.com/terraform-google-modules/terraform-google-address/compare/v3.1.0...v3.1.1) (2022-02-02)


### Bug Fixes

* Remove need for deprecated template terraform provider ([#38](https://github.com/terraform-google-modules/terraform-google-address/issues/38)) ([a6d91de](https://github.com/terraform-google-modules/terraform-google-address/commit/a6d91de9ab21851f002c95a4fad5cfca70d257bc))

## [3.1.0](https://www.github.com/terraform-google-modules/terraform-google-address/compare/v3.0.0...v3.1.0) (2021-12-14)


### Features

* update TPG version constraints to allow 4.0 ([#35](https://www.github.com/terraform-google-modules/terraform-google-address/issues/35)) ([537186d](https://www.github.com/terraform-google-modules/terraform-google-address/commit/537186da3e127fb55b47375877517686d0a9d3a0))

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
