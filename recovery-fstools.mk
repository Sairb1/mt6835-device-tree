LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),ossi)
PRODUCT_COPY_FILES += \
    system/bin/fsck.f2fs:root/sbin/fsck.f2fs \
    system/bin/mkfs.f2fs:root/sbin/mkfs.f2fs \
    system/bin/fsck.erofs:root/sbin/fsck.erofs \
    system/bin/mkfs.erofs:root/sbin/mkfs.erofs
endif

