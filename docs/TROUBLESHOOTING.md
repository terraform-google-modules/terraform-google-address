# Troubleshooting Guide

The following errors and solutions have been identified through the use of this module:

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
