# Changelog

## [2.0.0](https://github.com/danylomikula/terraform-hcloud-server/compare/v1.0.0...v2.0.0) (2026-05-03)


### ⚠ BREAKING CHANGES

* removed `datacenter` input and the `datacenter` and `backup_window` outputs from the `servers` map. Consumers must switch to `location` for server placement and to the `backups` boolean to check whether backups are enabled. Minimum supported Terraform raised to 1.13.0 and minimum hcloud provider to 1.62.0.

### Features

* align module with provider v1.62.0 ([#3](https://github.com/danylomikula/terraform-hcloud-server/issues/3)) ([8a11ff4](https://github.com/danylomikula/terraform-hcloud-server/commit/8a11ff4e8a6aea66a5abcecd1f2b4105f7189a41))

## 1.0.0 (2025-11-24)


### Features

* initial release ([#1](https://github.com/danylomikula/terraform-hcloud-server/issues/1)) ([5ae6832](https://github.com/danylomikula/terraform-hcloud-server/commit/5ae6832c322a362f8c599ebe4ea5b33a62680aae))
