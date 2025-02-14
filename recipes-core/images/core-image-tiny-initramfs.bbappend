include ${@bb.utils.contains('DISTRO_FEATURES', 'podman', 'core-image-tiny-initramfs.inc', '', d)}
