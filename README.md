# Device tree for the moto g power 5G - 2024 (cancunn)

| Basic                   | Spec Sheet                                         |
| -----------------------:|:-------------------------------------------------- |
| SoC                     | MediaTek Dimensity 7020 (MT6855)                   |
| CPU                     | 2x 2.2 GHz Cortex-A78 + 6x 2.0 GHz Cortex-A55      |
| GPU                     | IMG BXM-8-256                                      |
| Memory                  | 8 GB                                               |
| Shipped Android Version | 14 (vendor 12, GRF)                                |
| Storage                 | 128/256 GB UFS 2.2                                 |
| Battery                 | 5000 mAh, wireless charging                        |
| Display                 | 6.7" 1080 x 2400, 120 Hz                           |

LineageOS 23.2 (Android 16 QPR2) for the XT2415V, built on
`device/motorola/mt6855-common` with prebuilt stock kernels from
`device/motorola/cancunn-kernels`.

## Status

Tested on XT2415V (TracFone) with stock firmware `V1UDS35H.26-14-6-2-9`,
SELinux enforcing, release-keys build:

- Working: display (120 Hz), touch, GPU, Wi-Fi, Bluetooth, both cameras,
  speaker audio, fingerprint (FPC, power key), NFC, GPS, sensors, vibration,
  mobile data, adaptive brightness, GApps (MindTheGapps) and the Google eSIM
  manager.
- Not yet tested: voice calls/VoLTE, SMS, headset and USB audio, microSD
  storage.
- Known issues: the ERM vibration motor makes slider haptics feel buzzy;
  `dumpsys nfc` reports the controller firmware as unknown (cosmetic).

## Before flashing

There is no public firehose/BROM access for this device, so a bad flash of a
bootloader-chain partition is not recoverable. Only ever flash `boot`,
`vendor_boot`, `dtbo`, `vbmeta`, `vbmeta_system` and `super`; never flash
`preloader`, `lk`, `tee`, `gz`, `sspm` or other firmware, and never relock the
bootloader with a custom build. The builds do not package firmware.

The device trees and blobs target stock `V1UDS35H.26-14-6-2-9`; the
bootloader-chain firmware on the device should match it.

Motorola's bootloader checks each image against the vbmeta currently on the
device ("Preflash validation failed"), so flash vbmeta first:

```sh
fastboot flash vbmeta_a vbmeta.img
fastboot flash vbmeta_system_a vbmeta_system.img
fastboot flash boot_a boot.img
fastboot flash vendor_boot_a vendor_boot.img
fastboot flash dtbo_a dtbo.img
fastboot flash super super.img
```

Then boot to recovery, format data on first install, and optionally sideload
GApps before the first boot. The bootloader drops the vendor_boot bootconfig
section, so `androidboot.*` options must go on the kernel command line.

## Building

Add the out-of-tree dependencies to a local manifest:

```xml
<manifest>
  <project path="hardware/mediatek" name="LineageOS/android_hardware_mediatek" remote="github" revision="lineage-23.2" />
  <project path="device/mediatek/sepolicy_vndr" name="LineageOS/android_device_mediatek_sepolicy_vndr" remote="github" revision="lineage-23.2" />
  <project path="hardware/motorola" name="LineageOS/android_hardware_motorola" remote="github" revision="lineage-23.2" />
</manifest>
```

plus this tree, `mt6855-common` and `cancunn-kernels`, then:

```sh
source build/envsetup.sh
lunch lineage_cancunn-bp4a-userdebug
m bacon superimage
```

Requirements beyond the device trees:

- **libgui on a 5.10 kernel.** Android 16's `BLASTBufferQueue` waits for
  buffer releases with `epoll_pwait2()`, which needs Linux 5.11. On this
  android12-5.10 GKI every call fails with `ENOSYS` and the UI janks badly.
  `frameworks/native` needs a fallback to `epoll_wait()` (see
  `libs/gui/BLASTBufferQueue.cpp`, `BufferReleaseReader::readBlocking`).
- **Release keys.** On secure hardware, the stock Trustonic `mcDriverDaemon`
  loads trusted apps from the `tzapp` partition when `ro.build.tags` is
  exactly `test-keys`, and the secure world then halts (no KeyMint, so the
  first boot fails at `init_user0`). Sign builds with your own keys, e.g. with
  `lineage/scripts/lineage-priv-template` in `vendor/lineage-priv/keys`.

## Extracting proprietary files

Blobs come from stock `V1UDS35H.26-14-6-2-9` (XT2415V). Point the extractor at
a directory holding the stock partitions mounted or extracted side by side
(`system/`, `system_ext/`, `product/`, `vendor/`, `vendor_dlkm/`, `odm/`):

```sh
./extract-files.py /path/to/stock-root
```

Kernel prebuilts are extracted from the stock boot images with
`device/motorola/cancunn-kernels/extract-stock-kernel.sh`.
