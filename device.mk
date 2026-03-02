LOCAL_PATH := device/oplus/ossi

# Dynamic Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Virtual A/B
ENABLE_VIRTUAL_AB := true
AB_OTA_UPDATER := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)

# A/B OTA partitions — MT6835 names (not MT6983: no lk/lk2, no audio_dsp, no cam_vpu1-3, no cdt_engineering)
AB_OTA_PARTITIONS := \
    boot \
    dtbo \
    gz \
    init_boot \
    lk1 \
    mcupm \
    md1img \
    odm \
    odm_dlkm \
    pi_img \
    preloader_raw \
    product \
    scp \
    spmfw \
    sspm \
    system \
    system_ext \
    tee \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_boot \
    vendor_dlkm \
    my_bigball \
    my_carrier \
    my_company \
    my_engineering \
    my_heytap \
    my_manifest \
    my_preload \
    my_product \
    my_region \
    my_stock

# Boot HAL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2-service

# Health HAL
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

# Fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    fastbootd

# OTA
PRODUCT_PACKAGES += \
    otapreopt_script \
    update_engine \
    update_verifier \
    update_engine_sideload

# MTK boot control
PRODUCT_PACKAGES += \
    bootctrl.mt6835 \
    bootctrl.mt6835.recovery

PRODUCT_PACKAGES_DEBUG += \
    bootctrl

# Emulated storage
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# API levels — stock vendor is API 33 (Android 13), shipping on TWRP 14 branch
PRODUCT_SHIPPING_API_LEVEL := 33
PRODUCT_TARGET_VNDK_VERSION := 33

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

PRODUCT_PACKAGES -= ExampleVibratorJavaProductClient
