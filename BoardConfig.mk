DEVICE_PATH := device/oplus/ossi
ALLOW_MISSING_DEPENDENCIES := true

# ── Architecture ───────────────────────────────────────────────────────────────
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a55

# FIX: was armv8-2a which is invalid for 32-bit secondary arch
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a55

TARGET_BOARD_SUFFIX := _64
TARGET_SUPPORTS_64_BIT_APPS := true
TARGET_IS_64_BIT := true

# ── Platform ───────────────────────────────────────────────────────────────────
TARGET_BOARD_PLATFORM := mt6835
TARGET_BOARD_PLATFORM_GPU := mali-g57mc2
TARGET_BOOTLOADER_BOARD_NAME := k6835v1_64
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true
BOARD_HAS_MTK_HARDWARE := true
BOARD_USES_MTK_HARDWARE := true
MTK_HARDWARE := true

# ── Security patch — fake-future prevents TEE/AVB rollback rejecting our TWRP key ──
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := 14
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := 2099-12-31
BOOT_SECURITY_PATCH := 2099-12-31

# ── Kernel ─────────────────────────────────────────────────────────────────────
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_NO_KERNEL := true
BOARD_RAMDISK_USE_LZ4 := true
BOARD_KERNEL_SEPARATED_DTBO := true

TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img

BOARD_KERNEL_BASE        := 0x3FFF8000
BOARD_PAGE_SIZE          := 4096
BOARD_KERNEL_OFFSET      := 0x00008000
BOARD_RAMDISK_OFFSET     := 0x26F08000
BOARD_TAGS_OFFSET        := 0x07C88000
BOARD_BOOT_HEADER_VERSION := 4
BOARD_DTB_SIZE           := 327372
BOARD_DTB_OFFSET         := 0x07C88000
BOARD_HEADER_SIZE        := 2128
BOARD_VENDOR_CMDLINE     := bootopt=64S3,32N2,64N2

BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
BOARD_MKBOOTIMG_ARGS += --vendor_cmdline $(BOARD_VENDOR_CMDLINE)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_PAGE_SIZE) --board ""
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)

# ── Partition sizes ────────────────────────────────────────────────────────────
BOARD_FLASH_BLOCK_SIZE             := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE     := 67108864
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864

# ── Dynamic / super partitions ────────────────────────────────────────────────
BOARD_SUPER_PARTITION_SIZE := 9653190656
BOARD_SUPER_PARTITION_GROUPS := oplus_dynamic_partitions
BOARD_OPLUS_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    odm odm_dlkm product system system_ext vendor vendor_dlkm
# FIX: was 9648996352 correctly, kept
BOARD_OPLUS_DYNAMIC_PARTITIONS_SIZE := 9648996352

BOARD_PARTITION_LIST := $(call to-upper, $(BOARD_OPLUS_DYNAMIC_PARTITIONS_PARTITION_LIST))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := erofs))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval TARGET_COPY_OUT_$(p) := $(call to-lower,$(p))))

# ── File systems ───────────────────────────────────────────────────────────────
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

BOARD_USES_VENDOR_DLKMIMAGE := true
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm

BOARD_USES_ODM_DLKMIMAGE := true
BOARD_ODM_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_ODM_DLKM := odm_dlkm

BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_SYSTEM_EXT := system_ext

# ── Recovery / ramdisk — Virtual A/B GKI style ────────────────────────────────
TARGET_NO_RECOVERY := true
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT :=
TW_LOAD_VENDOR_BOOT_MODULES := true

TARGET_RECOVERY_FSTAB    := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_SYSTEM_PROP       += $(DEVICE_PATH)/system.prop
TARGET_RECOVERY_DEVICE_MODULES += libmtk_bsg
TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/libmtk_bsg.so

# ── Metadata ───────────────────────────────────────────────────────────────────
BOARD_USES_METADATA_PARTITION := true
BOARD_ROOT_EXTRA_FOLDERS += metadata

# ── AVB ────────────────────────────────────────────────────────────────────────
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# ── VNDK / Treble ─────────────────────────────────────────────────────────────
BOARD_VNDK_VERSION := current
# FIX: stock vendor is SDK 33, not 34
BOARD_SYSTEMSDK_VERSIONS := 33

# ── Crypto / FBE v2 ───────────────────────────────────────────────────────────
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_USE_FSCRYPT_POLICY := 2
TW_PREPARE_DATA_MEDIA_EARLY := true

# Trustonic KeyMint 2.0 blobs — already present in recovery/root/vendor/
# FIX: removed libkeymaster4.1 (wrong generation); using actual blobs from DT
TARGET_RECOVERY_DEVICE_MODULES += \
    libMcClient \
    libMcTeeSoter \
    android.hardware.security.keymint-V2-ndk \
    android.hardware.security.secureclock-V1-ndk \
    android.hardware.security.sharedsecret-V1-ndk \
    vendor.trustonic.hardware.soter-V1-ndk \
    gatekeeper.trustonic \
    libMcGatekeeper

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/libMcClient.so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/libMcTeeSoter.so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/android.hardware.security.keymint-V2-ndk.so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/android.hardware.security.secureclock-V1-ndk.so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/android.hardware.security.sharedsecret-V1-ndk.so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/vendor.trustonic.hardware.soter-V1-ndk.so

# ── Display ────────────────────────────────────────────────────────────────────
TARGET_SCREEN_HEIGHT  := 2400
TARGET_SCREEN_WIDTH   := 1080
TARGET_SCREEN_DENSITY := 320

# ── TWRP UI ────────────────────────────────────────────────────────────────────
TW_THEME              := portrait_hdpi
TW_STATUS_ICONS_ALIGN := centre
TW_Y_OFFSET           := 104
TW_H_OFFSET           := -104
TW_BRIGHTNESS_PATH    := "/sys/class/leds/lcd-backlight/brightness"
TW_DEFAULT_BRIGHTNESS := 1632
TW_MAX_BRIGHTNESS     := 3264
TW_SCREEN_BLANK_ON_BOOT := true
TW_FRAMERATE          := 120
TW_CUSTOM_CPU_POS     := "60"
TW_CUSTOM_CLOCK_POS   := "455"
TW_CUSTOM_BATTERY_POS := "790"

# ── TWRP tools ─────────────────────────────────────────────────────────────────
TW_INCLUDE_FASTBOOTD      := true
TW_INCLUDE_RESETPROP      := true
TW_INCLUDE_REPACKTOOLS    := true
TW_INCLUDE_LIBRESETPROP   := true
TW_INCLUDE_LPDUMP         := true
TW_INCLUDE_LPTOOLS        := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXCLUDE_APEX           := true
TW_INCLUDE_NTFS_3G        := true
TW_INCLUDE_FUSE_EXFAT     := true
TW_EXTRA_LANGUAGES        := true
TW_INPUT_BLACKLIST        := "hbtp_vm"
TW_BATTERY_SYSFS_WAIT_SECONDS := 6
TW_BACKUP_EXCLUSIONS      := /data/fonts
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /config/usb_gadget/g1/functions/mass_storage.usb0/lun.%d/file
TARGET_USES_MKE2FS        := true
TW_DEVICE_VERSION         := @imnotaino


# ── Debug ──────────────────────────────────────────────────────────────────────
TARGET_USES_LOGD   := true
TWRP_INCLUDE_LOGCAT := true

# ── Build broken flags ─────────────────────────────────────────────────────────
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
