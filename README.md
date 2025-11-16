```markdown
# TWRP Device Tree – realme Narzo 60x 5G (RMX3782) / MT6835

Device tree for building TWRP 3.7.x for **realme Narzo 60x 5G (RMX3782)**, based on **MediaTek MT6835 / Dimensity 6100+** platform.
Twrp Branch 12.1

This repo exists because the device boots TWRP successfully, but `/data` cannot be mounted or decrypted due to FBEv2 / Keymint / F2FS issues. All findings are documented here so other devs can help finish it.

---

## Device Info

- **Device:** realme Narzo 60x 5G  
- **Model:** RMX3782  
- **Version:** Android 14, OS Based Android 13  
- **OTA Version:** RMX3782.14.0.0.115(EX01SF01)  
- **SoC:** MediaTek Dimensity 6100+ (MT6835)  
- **Display:** 6.72" 2400×1080, 120Hz IPS LCD  
- **Storage:** 128 GB UFS 2.2  
- **OS Base:** Android 13 (realme UI 4.0)  
- **Dynamic partitions:** Yes  
- **Encryption:** FBEv2 + fscrypt + KeyMint

---

## Partition & FS Layout

### Dynamic EROFS partitions
- system
- system_ext
- vendor
- product
- odm
- vendor_dlkm
- odm_dlkm
- + multiple `my_*` partitions

### Static partitions
- **/metadata:** f2fs — mounts fine
- **/cache:** ext4 — mounts fine
- **/data:** f2fs (FBEv2) — **does NOT mount in TWRP**

---

## Current Status

### Works
✔ TWRP boots (via vendor_boot)  
✔ Display, touch, UI  
✔ `/metadata` & `/cache` mount  
✔ Dynamic partitions mapped correctly (`dm-*` symlinks created)  
✔ `vold` injected into ramdisk at `/sbin/vold`  

### Broken / WIP
❌ `/data` will not mount (Magic Mismatch)  
❌ FBE decryption unsupported (KeyMint not detected)  
❌ `keystore2` crashes if not disabled  
❌ Vendor partitions not auto-mounted (EROFs + first_stage_mount)  

---

## /data Mount Issue (Main Problem)

Even after clean formatting:

```

fastboot format:userdata

```

Kernel still reports: F2FS-fs (sdc79): Magic Mismatch, valid(0xf2f52010) - read(0x89bc54f8)
F2FS-fs (sdc79): Can't find valid F2FS filesystem


```


```

And TWRP log: I:Can't probe device /dev/block/sdc79
I:Unable to mount '/data'

```



```

So the issue is **not corrupt userdata**. It is a kernel/F2FS/FBE mismatch or wrong block mapping.

---

## KeyMint / Keystore2 Status

`vold` is present, but keymaster detection still fails: I:Keymaster_Ver::Unable to find vendor manifest
I:Keymaster_Ver::Using keymaster version '' for decryption
 
```



````

`keystore2` also crashes unless stopped in init.


---

## Needed Help

If you're familiar with:

* FBEv2 + KeyMint in TWRP
* MediaTek recovery kernel + F2FS differences
* Handling vold / keystore2 / fscrypt on Android 13+

Then the missing pieces are:

1. Fix `/data` mount (correct F2FS superblock handling or block device path)
2. Properly detect KeyMint / provide keymaster HAL version
3. Clean handling of `keystore2` without hacks
4. Optional: dynamic partition mounting (EROFs) for vendor access

---

## Build Instructions

```bash
git clone https://github.com/Sairb1/rmx3782-mt6835-working-device-tree device/oplus/ossi

. build/envsetup.sh
lunch twrp_ossi-eng
mka vendorbootimage 
```

This tree uses **prebuilt dtb** and boots through `vendor_boot`.

---

## Notes

This TWRP **boots successfully**, so the bring-up is nearly complete.
The last major blocker is **/data FBE mount + decryption**, caused by F2FS + KeyMint issues in recovery.
Logs are included in this repo (`/logs`) for anyone who wants to debug further.

PRs / forks / fixes welcome.

```

Join t.me/realme11x
```
