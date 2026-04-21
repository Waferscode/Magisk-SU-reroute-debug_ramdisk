# Magisk SU Reroute To Debug Ramdisk

Routes common `su` paths to `/debug_ramdisk/su`.

Useful on devices where:

- Magisk root works
- `/debug_ramdisk/su` works from apps
- `/system/xbin/su` does not

Installed paths:

- `/system/bin/su`
- `/system/xbin/su`
- `/system/sbin/su`

`post-fs-data.sh` also tries to link:

- `/sbin/su`
- `/su/bin/su`

## Build

```bash
./build-module.sh
```

## Install

```bash
adb push ./su-reroute-debug-ramdisk-v1.0.zip /sdcard/Download/
adb shell su -c 'magisk --install-module /sdcard/Download/su-reroute-debug-ramdisk-v1.0.zip'
adb reboot
```

## Verify

```bash
adb shell '/system/bin/su -c id'
adb shell '/system/xbin/su -c id'
```
