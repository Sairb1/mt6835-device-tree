# TWRP Device Tree — Realme 11 Series (ossi)

> **Branch:** `android-14`  
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

Adb working,
twrp not booting, 
idk abt decryption

---

Output: `out/target/product/ossi/vendor_boot.img`

### Flash

```

## Credits

- TWRP Team
- @notpiyushbro — Device tree, branch migration, some fixes
- Sairb1- @imnotaino 
