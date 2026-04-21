#!/system/bin/sh

# Best-effort legacy symlinks for wrappers that probe outside /system.
for target in /sbin/su /su/bin/su; do
  parent="${target%/*}"
  [ -d "$parent" ] || continue

  current="$(readlink "$target" 2>/dev/null)"
  [ "$current" = "/debug_ramdisk/su" ] && continue

  rm -f "$target" 2>/dev/null
  ln -s /debug_ramdisk/su "$target" 2>/dev/null
done
