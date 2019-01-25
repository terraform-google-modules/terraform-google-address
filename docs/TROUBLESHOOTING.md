# Troubleshooting Guide

The following errors and solutions have been identified through the use of this module:

## Input variable validation fails

There are two null_resources that provide validation in the event that
`var.enable_cloud_dns` or `var.ptr_args_missing` are enabled. The purpose is
to verify that there are values for all the input variables that are required
by those two feature. The validation for `var.enable_cloud_dns` makes sure there
are values for `var.dns_domain`, `var.dns_project`, and `var.dns_managed_zone`, and the validation
for `var.enable_reverse_dns` makes sure there's a value for `var.dns_reverse_zone`.


**Error message:**

```
 Error: module.example.module.address.null_resource.dns_args_missing: : invalid or unknown key: ERROR: Variable `enable_cloud_dns` was passed to enable DNS registration. Please provide values for the `dns_domain`, `dns_project`, and `dns_managed_zone` input variables to continue

OR

 Error: module.example.module.address.null_resource.ptr_args_missing: : invalid or unknown key: ERROR: Variable `enable_reverse_dns` was passed to enable reverse DNS registration. Please provide a value for the `dns_reverse_zone` input variable to continue
 ```

**Cause:**

If you're certain that you're providing values for the input variables
provided and this error has surfaced during `terraform validate` then
validation is failing because you're most likely passing a computed value
instead of a string literal value for one or more of the input variables
identified. Because `terraform validate` can't compute the value, it's registering
it as an empty value which surfaces this error. See the section in the [README](https://github.com/terraform-google-modules/terraform-google-address/blob/master/README.md)
document on "Input variables that cannot contain computed values".

**Solution:**

Ensure that you're passing string literal (and not computed) values
for the following input variables:

```
var.dns_domain
var.dns_project
var.dns_managed_zone
var.dns_reverse_zone
```

## The value of 'count' cannot be computed

The value of the `count` variable is determined conditionally on all of the
resources within this module. The value of `count` cannot be a computed value,
and if it is then the following error will arise:

**Error message:**

```
Error: Error running plan: 2 error(s) occurred:

       * module.example.module.address.google_dns_record_set.ip: google_dns_record_set.ip: value of 'count' cannot be computed
       * module.example.module.address.google_dns_record_set.ptr: google_dns_record_set.ptr: value of 'count' cannot be computed
```

**Cause:**

This error arises if the value of one of the following input variables
is a computed value:

```
var.dns_domain
var.dns_short_names
var.enable_cloud_dns
var.enable_reverse_dns
var.global
var.names
```

**Solution:**

Ensure that the values for the listed input variables are literal values (or
arrays/maps that contain literal values).
