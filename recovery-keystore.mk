# device/oplus/ossi/recovery-keystore.mk
LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),ossi)

# keystore / keymint / vendor security binaries (from proprietary folder)
PRODUCT_COPY_FILES += \
    device/oplus/ossi/proprietary/vendor/bin/hw/android.hardware.security.keymint@2.0-service.trustonic:root/vendor/bin/hw/android.hardware.security.keymint@2.0-service.trustonic \
    device/oplus/ossi/proprietary/vendor/bin/hw/android.hardware.gatekeeper@1.0-service:root/vendor/bin/hw/android.hardware.gatekeeper@1.0-service \
    device/oplus/ossi/proprietary/vendor/bin/hw/vendor.trustonic.soter@1.0-service:root/vendor/bin/hw/vendor.trustonic.soter@1.0-service

# vendor helper binaries
PRODUCT_COPY_FILES += \
    device/oplus/ossi/proprietary/vendor/bin/mcDriverDaemon:root/vendor/bin/mcDriverDaemon \
    device/oplus/ossi/proprietary/vendor/bin/vndservice:root/vendor/bin/vndservice \
    device/oplus/ossi/proprietary/vendor/bin/vndservicemanager:root/vendor/bin/vndservicemanager

# vendor libraries: TEE / keymaster / gatekeeper pieces (64-bit)
PRODUCT_COPY_FILES += \
    device/oplus/ossi/proprietary/vendor/lib64/libMcClient.so:root/vendor/lib64/libMcClient.so \
    device/oplus/ossi/proprietary/vendor/lib64/libkmsetkey.so:root/vendor/lib64/libkmsetkey.so \
    device/oplus/ossi/proprietary/vendor/lib64/libMcTeeSoter.so:root/vendor/lib64/libMcTeeSoter.so \
    device/oplus/ossi/proprietary/vendor/lib64/libMcGatekeeper.so:root/vendor/lib64/libMcGatekeeper.so \
    device/oplus/ossi/proprietary/vendor/lib64/libSoftGatekeeper.so:root/vendor/lib64/libSoftGatekeeper.so \
    device/oplus/ossi/proprietary/vendor/lib64/gatekeeper.trustonic.so:root/vendor/lib64/gatekeeper.trustonic.so \
    device/oplus/ossi/proprietary/vendor/lib64/libladder.so:root/vendor/lib64/libladder.so \
    device/oplus/ossi/proprietary/vendor/lib64/libTEECommon.so:root/vendor/lib64/libTEECommon.so \
    device/oplus/ossi/proprietary/vendor/lib64/vendor.trustonic.hardware.soter-V1-ndk.so:root/vendor/lib64/vendor.trustonic.hardware.soter-V1-ndk.so

# keymint NDK glue (critical)
PRODUCT_COPY_FILES += \
    device/oplus/ossi/proprietary/vendor/lib64/android.hardware.security.keymint-V2-ndk.so:root/vendor/lib64/android.hardware.security.keymint-V2-ndk.so

# Optional 32-bit glue if present
PRODUCT_COPY_FILES += \
    device/oplus/ossi/proprietary/vendor/lib/android.hardware.security.keymint-V2-ndk.so:root/vendor/lib/android.hardware.security.keymint-V2-ndk.so

# vendor hw module dir
PRODUCT_COPY_FILES += \
    device/oplus/ossi/proprietary/vendor/lib64/hw/android.hardware.gatekeeper@1.0-impl.so:root/vendor/lib64/hw/android.hardware.gatekeeper@1.0-impl.so

# vendor vintf manifest (so KeyMint / keystore2 are discoverable)
PRODUCT_COPY_FILES += \
    device/oplus/ossi/proprietary/vendor/etc/vintf/manifest.xml:root/vendor/etc/vintf/manifest.xml \
    device/oplus/ossi/proprietary/vendor/etc/vintf/manifest_mt6835.xml:root/vendor/etc/vintf/manifest_mt6835.xml

# optional firmware dir
PRODUCT_COPY_FILES += \
    device/oplus/ossi/proprietary/vendor/etc/firmware:root/vendor/etc/firmware

endif

