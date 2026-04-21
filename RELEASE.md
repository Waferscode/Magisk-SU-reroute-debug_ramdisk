# Release v1.0

Initial public release of the Magisk module that reroutes common system `su`
paths to `/debug_ramdisk/su`.

## Why this release exists

On the target Android TV 14 board:

- Magisk root was present
- app-root requests were unreliable
- `/debug_ramdisk/su` worked from app processes
- `/system/xbin/su` could fail with `Permission denied`

This module restores app-facing root for the common `su` paths without needing
to patch every root app individually.

## Included

- wrappers for `/system/bin/su`
- wrappers for `/system/xbin/su`
- wrappers for `/system/sbin/su`
- best-effort legacy symlink setup for `/sbin/su` and `/su/bin/su`

## Notes

- best suited for devices with the same `debug_ramdisk` behavior
- not a universal fix for every root-detection issue
- if the platform blocks execution by path, a deeper hook may still be needed

## Asset

Attach:

- `su-reroute-debug-ramdisk-v1.0.zip`
