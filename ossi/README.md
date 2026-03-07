# TWRP Device Tree — Realme 11 Series (ossi)

> **Branch:** `android-14` / TWRP 14.0  
> **Maintainer:** @imnotaino

---

## Device Specifications

| Property | Value |
|---|---|
| **Device** | Realme 11, 11x, Narzo 60X and C67 5G |
| **Codename** | ossi |
| **SoC** | MediaTek Dimensity 6100+ (MT6835) |
| **GPU** | Mali-G57 MC2 |
| **Architecture** | ARM64 (Cortex-A55) |
| **Android** | 14 (vendor SDK 33) |
| **Boot method** | Virtual A/B (GKI), vendor_boot |
| **Encryption** | FBE v2 — `aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized` |
| **TEE** | Trustonic MobiCore (KeyMint 2.0) |
| **Storage** | UFS — `/dev/block/by-name/userdata` |
| **Kernel** | Prebuilt GKI (boot header v4) |

---

## Status

| Feature | Status |
|---|---|
| Booting | ✅ Working |
| Touch | ✅ Working |
| Display | ✅ Working (120Hz Probably) |
| USB OTG | ✅ Working |
| MicroSD | ✅ Working |
| ADB | ✅ Working |
| Fastbootd | ✅ Working |
| Backup / Restore | ✅ Working |
| /data decryption (FBE v2) | ✅ Working |
| Flash ZIP | ✅ Working |
| Flash Images | ✅ Working |

---

## Building

### Prerequisites

- Ubuntu 20.04 / 22.04 (native or **WSL2 only** — WSL1 not supported)
- 16 GB RAM minimum

Output: `out/target/product/ossi/vendor_boot.img`

### Flash

```

---

## Migration: branch twrp-12.1 → twrp-14

Complete changelog of every file changed and why.

---

### `recovery/root/init.recovery.mt6835.rc` — Full rewrite

#### Added: TEE / KeyMint services (critical for FBE v2)

```

#### Removed: `chmod 000 keystore2`

The 12.1 "patched" version contained this line which stripped execute permission from keystore2 — the exact binary responsible for decryption. Removed entirely.

#### Removed: broken userdata poll loop

The original polled for `/dev/block/mapper/userdata` which does not exist on this device. Userdata is a raw block device at `/dev/block/by-name/userdata`, not a device-mapper node. The loop ran all 80 iterations (~6 second hang) on every boot achieving nothing.

#### Removed: three competing vold service definitions

`vold`, `vold_vendor`, and `vold_system` were all defined but disabled. TWRP manages vold internally — having extra definitions in init.rc causes conflicts. Removed entirely.

#### Removed: `wait_for_keymaster` service

Referenced `libkeymaster4_1support.so` (Keymaster 4 generation) which does not exist on this device (uses KeyMint 2.0). Also tried to manually `start vold`, conflicting with TWRP's internal vold management. Removed entirely.

#### Removed: shell exec blocks in early-init

Called `/system/bin/sh` at `early-init` stage when `/system` is not yet mounted. These blocks silently failed every time. Removed entirely.

---

### `recovery/root/system/etc/recovery.fstab` — Full rewrite

#### /data encryption: wrong separator (critical decryption bug)

TWRP's fstab parser splits `flags=` values on semicolons (`;`). The original used a comma between `fileencryption` and `keydirectory`, so `keydirectory` was silently discarded on every parse. TWRP never knew where the metadata encryption key lived.

```
# OLD — comma separator, keydirectory silently ignored
flags=...fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized,keydirectory=/metadata/vold/metadata_encryption

# NEW — semicolon separator, keydirectory correctly parsed
flags=display=Data;backup=1;fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized;keydirectory=/metadata/vold/metadata_encryption
```

#### Removed: entire MT6983 raw fstab block at top of file

The file contained a raw Linux first-stage fstab from an MT6983 device at the top. TWRP ignores raw fstab format entries entirely, but the wrong platform partition names it contained (see below) still caused mount failures. Removed.

#### Wrong partition names (MT6983 → MT6835)

| Removed (MT6983) | Replaced with (MT6835) |
|---|---|
| `sspm_1` / `sspm_2` | `sspm1` / `sspm2` |
| `dpm_1` / `dpm_2` | `dpm1` / `dpm2` |
| `mcupm_1` / `mcupm_2` | `mcupm1` / `mcupm2` |
| `lk` / `lk2` | `lk1` / `bootloader2` |
| `cam_vpu1` / `cam_vpu2` / `cam_vpu3` | *(removed — MT6835 has no cam_vpu)* |
| `audio_dsp` | *(removed — MT6835 has no audio_dsp)* |
| `cdt_engineering` | *(removed)* |
| `/recovery` | *(removed — Virtual A/B has no recovery partition)* |

#### Added: missing Android 14 partitions

`/system_ext`, `/vendor_dlkm`, `/odm_dlkm`, `/init_boot` were all absent from the 12.1 fstab.

#### Fixed: USB controller path

```

# NEW — MT6835 controller
/devices/platform/soc/11201000.usb0/11200000.xhci*
```

---

### `recovery/root/first_stage_ramdisk/fstab.mt6835` — Full rewrite

#### Missing AVB keys on odm and all my_* partitions

Stock ROM fstab has `avb_keys=/vendor/etc/oplus_avb.pubkey` on odm and every `my_*` logical partition. The 12.1 fstab omitted all of them. Without the key, AVB verification stalls during first-stage mount and the logical partition tree never loads.

```
# NEW — added to odm and all my_* partitions
odm ... avb_keys=/vendor/etc/oplus_avb.pubkey
my_product ... avb_keys=/vendor/etc/oplus_avb.pubkey
my_engineering ... avb_keys=/vendor/etc/oplus_avb.pubkey
my_company ... avb_keys=/vendor/etc/oplus_avb.pubkey
my_carrier ... avb_keys=/vendor/etc/oplus_avb.pubkey
my_region ... avb_keys=/vendor/etc/oplus_avb.pubkey
my_heytap ... avb_keys=/vendor/etc/oplus_avb.pubkey
my_stock ... avb_keys=/vendor/etc/oplus_avb.pubkey
my_preload ... avb_keys=/vendor/etc/oplus_avb.pubkey
my_bigball ... avb_keys=/vendor/etc/oplus_avb.pubkey
my_manifest ... avb_keys=/vendor/etc/oplus_avb.pubkey
```

#### /data flags match stock ROM exactly

Added `fsverity` flag and correct `keydirectory` path, matching `/vendor/etc/fstab.mt6835` from stock ROM:

```
fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized,keydirectory=/metadata/vold/metadata_encryption,fsverity
```

#### Partition names corrected (same MT6983 → MT6835 table as recovery.fstab above)

---

### `BoardConfig.mk` — Full rewrite

| Variable | Old value | New value | Reason |
|---|---|---|---|
| `PLATFORM_VERSION` | `14` | `99.87.36` | Fake-future prevents TEE rollback rejection |
| `PLATFORM_SECURITY_PATCH` | *(missing)* | `2099-12-31` | AVB rollback bypass |
| `VENDOR_SECURITY_PATCH` | *(missing)* | `2099-12-31` | AVB rollback bypass |
| `BOOT_SECURITY_PATCH` | *(missing)* | `2099-12-31` | AVB rollback bypass |
| `TARGET_2ND_ARCH_VARIANT` | `armv8-2a` | `armv7-a-neon` | armv8-2a invalid for 32-bit arch |
| `BOARD_SYSTEMSDK_VERSIONS` | `34` | `33` | Stock vendor is SDK 33 |
| Crypto modules | `libkeymaster4.1` | Trustonic KeyMint 2.0 blobs | Wrong HAL generation |
| `BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT` | present | removed | Caused packaging issues on TWRP 14 |

---

### `device.mk` — Partial rewrite

| Change | Old | New | Reason |
|---|---|---|---|
| `PRODUCT_SHIPPING_API_LEVEL` | `32` | `33` | Matches stock vendor |
| `PRODUCT_TARGET_VNDK_VERSION` | `34` | `33` | Matches stock vendor |
| A/B partition names | MT6983 names | MT6835 names | Wrong platform |
| Keymaster packages | `keymaster@4.x` | removed | Wrong HAL generation, device uses KeyMint 2.0 |

---

### `twrp_ossi.mk`

```makefile
# OLD — Android 13 fingerprint
BUILD_FINGERPRINT := oplus/ossi/ossi:13/TP1A.220905.001/1728970139244:user/release-keys

# NEW — Android 14 fingerprint
BUILD_FINGERPRINT := oplus/ossi/ossi:14/UP1A.231005.007/1728970139244:user/release-keys
```

---

### New blobs added

| File | Source | Purpose |
|---|---|---|
| `recovery/root/vendor/etc/oplus_avb.pubkey` | `adb pull /vendor/etc/oplus_avb.pubkey` | AVB key for odm + my_* logical partitions |
| `recovery/root/vendor/lib/libmtk_bsg.so` | `adb pull /vendor/lib/libmtk_bsg.so` | Boot HAL 1.2 dependency |
| `recovery/root/vendor/lib64/libmtk_bsg.so` | `adb pull /vendor/lib64/libmtk_bsg.so` | Boot HAL 1.2 dependency (64-bit) |

The Trustonic KeyMint 2.0 blobs (`mcDriverDaemon`, `keymint@2.0-service.trustonic`, `gatekeeper@1.0-service`, `libMcClient.so`, `libMcTeeSoter.so`, `mcRegistry/*.tabin/*.tlbin`) were already present in the 12.1 DT but were never started. No new blobs needed for TEE — just the init.rc services.

---

## Credits

- TWRP Team
- @notpiyushbro — Device tree, branch migration, some fixes
- Sairb1- @imnotaino 
