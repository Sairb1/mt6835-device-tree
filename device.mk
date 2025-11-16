#
# Copyright (C) 2024 The Android Open Source Project
# Copyright (C) 2024 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/oplus/ossi

PRODUCT_COPY_FILES += \
    device/oplus/ossi/proprietary/system/bin/vold:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/sbin/vold

# Dynamic Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Virtual A/B
ENABLE_VIRTUAL_AB := true
AB_OTA_UPDATER := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# A/B
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_PARTITIONS := \
    my_product \
    my_engineering \
    my_company \
    my_carrier \
    my_region \
    my_heytap \
    my_stock \
    my_preload \
    my_bigball \
    my_manifest \
    odm \
    product \
    system \
    system_ext \
    vendor \

AB_OTA_PARTITIONS += \
    audio_dsp \
    boot \
    cam_vpu1 \
    cam_vpu2 \
    cam_vpu3 \
    cdt_engineering \
    dpm \
    dtbo \
    gz \
    lk \
    mcupm \
    md1img \
    pi_img \
    preloader_raw \
    scp \
    spmfw \
    sspm \
    tee \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2-service

PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

PRODUCT_PACKAGES_DEBUG += \
    bootctrl

PRODUCT_PACKAGES += \
    bootctrl.mt6835 \
    bootctrl.mt6835.recovery

# Fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    fastbootd


# API
PRODUCT_SHIPPING_API_LEVEL := 32

# VNDK
PRODUCT_TARGET_VNDK_VERSION := 35

#
#PRODUCT_STATIC_BOOT_CONTROL_HAL := \
#    bootctrl.mt6835 \
#    libgptutils \
#    libz \
#    libcutils

PRODUCT_PACKAGES += \
#    bootctrl.mt6835 \
    libgptutils \
    libz \
    libcutils

PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_verifier \
    update_engine_sideload

# Additional binaries & libraries needed for recovery
TARGET_RECOVERY_DEVICE_MODULES += \
    libkeymaster4 \
    libkeymaster41


# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)
