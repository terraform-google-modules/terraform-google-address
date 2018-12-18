# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [v0.1.0](https://github.com/terraform-google-modules/terraform-google-address/releases/tag/v0.1.0)

### Added

This is the initial release of the module with basic support for:

- Reserving internal/external IP addresses
    - Optionally, being able to reserve specific IP addresses within a subnetwork (internal IP addresses only)
- Registering IP addresses with Google Cloud DNS
    - Forward and Reverse lookup zones are supported

