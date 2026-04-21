# Magisk SU Reroute To Debug Ramdisk

Magisk module for Android TV 14 devices where app-space root requests fail
when callers resolve `su` through the usual system paths.

On the affected board we debugged, app processes could execute
`/debug_ramdisk/su` but would fail with `Permission denied` on
`/system/xbin/su`. That broke root-aware apps and libraries even though
Magisk itself was installed and working.

This module reroutes the common system `su` entrypoints to
`/debug_ramdisk/su`.

## What it installs

- `/system/bin/su`
- `/system/xbin/su`
- `/system/sbin/su`

Each wrapper clears `LD_LIBRARY_PATH` and `LD_PRELOAD`, then forwards the
original arguments to `/debug_ramdisk/su`.

At boot, `post-fs-data.sh` also tries to create these legacy symlinks if
their parent directories already exist:

- `/sbin/su`
- `/su/bin/su`

## Why this exists

This is meant for boards where:

- Magisk root works from shell or ADB
- app-root requests are broken or inconsistent
- `/debug_ramdisk/su` works from app processes
- `/system/xbin/su` does not

If that pattern matches your device, this module can restore app-facing root
without patching each app individually.

## What it helps

- apps that launch plain `su`
- callers hardcoded to `/system/bin/su`
- some callers hardcoded to `/system/xbin/su`
- wrappers that probe `/system/sbin/su`

## What it does not promise

- apps that bundle their own `su` binary
- apps that fail before they try to execute `su`
- platforms that block execution by path regardless of the file contents
- cases that need a deeper exec hook instead of path redirection

## Install

1. Build the module zip:

```bash
./build-module.sh
```

2. Install the generated zip from the Magisk app, or with ADB:

```bash
adb push ./su-reroute-debug-ramdisk-v1.0.zip /sdcard/Download/
adb shell su -c 'magisk --install-module /sdcard/Download/su-reroute-debug-ramdisk-v1.0.zip'
adb reboot
```

## Verify

After reboot:

```bash
adb shell 'ls -l /system/bin/su /system/xbin/su /system/sbin/su 2>/dev/null'
adb shell '/system/bin/su -c id'
adb shell '/system/xbin/su -c id'
```

Expected result:

- the `su` paths exist
- the commands return `uid=0(root)`

## Tested scenario

This module was created while bringing up Android TV 14 on an Orange Pi 6 Plus
board. It may also help other boards that expose the same split between
`/debug_ramdisk/su` and the system `su` paths.

## Files

- `module.prop`: Magisk module metadata
- `post-fs-data.sh`: legacy symlink setup at boot
- `system/bin/su`: wrapper to `/debug_ramdisk/su`
- `system/xbin/su`: wrapper to `/debug_ramdisk/su`
- `system/sbin/su`: wrapper to `/debug_ramdisk/su`
- `build-module.sh`: packs the installable zip
