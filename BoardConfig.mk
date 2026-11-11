#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/motorola/cancunn
KERNEL_PATH := $(DEVICE_PATH)-kernels

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := cancunn

# Display
TARGET_SCREEN_DENSITY := 400

# Kernel
TARGET_KERNEL_DIR := $(KERNEL_PATH)/5.10
TARGET_PROVIDES_STATIC_MODULE_LISTS := true

BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(TARGET_KERNEL_DIR)/vendor_dlkm.modules.load))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(strip $(shell cat $(TARGET_KERNEL_DIR)/vendor_ramdisk.modules.load))
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(TARGET_KERNEL_DIR)/vendor_ramdisk.modules.load.recovery))

BOARD_KERNEL_MODULE_DIR := $(TARGET_KERNEL_DIR)
BOARD_PREBUILT_DTBIMAGE_DIR := $(TARGET_KERNEL_DIR)
BOARD_PREBUILT_DTBOIMAGE := $(TARGET_KERNEL_DIR)/dtbo.img
# Deferred: BOARD_KERNEL_IMAGE_NAME is set by BoardConfigCommon.mk, included below.
TARGET_PREBUILT_KERNEL = $(TARGET_KERNEL_DIR)/$(BOARD_KERNEL_IMAGE_NAME)
TARGET_PREBUILT_KERNEL_HEADERS := $(TARGET_KERNEL_DIR)/kernel-uapi-headers.tar.gz

ALL_VENDOR_RAMDISK_MODULES := $(sort $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD) $(BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD))
BOARD_VENDOR_KERNEL_MODULES := $(addprefix $(BOARD_KERNEL_MODULE_DIR)/,$(BOARD_VENDOR_KERNEL_MODULES_LOAD))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(addprefix $(BOARD_KERNEL_MODULE_DIR)/,$(ALL_VENDOR_RAMDISK_MODULES))

# Modules stock loads from init scripts rather than modules.load: connectivity
# drivers, touch, fingerprint, NFC, SAR, haptics, charging and Moto helpers.
BOARD_VENDOR_KERNEL_MODULES += \
    $(addprefix $(BOARD_KERNEL_MODULE_DIR)/, \
        aw862x.ko \
        aw9610x.ko \
        bt_drv_connac1x.ko \
        chipone_tddi_mmi_v2.ko \
        connfem.ko \
        cps4038_mmi.ko \
        fmradio_drv_mt6631_6635.ko \
        focaltech_0flash_mmi_v2.ko \
        fpc_mtk_tee.ko \
        goodix_fps_tee.ko \
        gps_drv_stp.ko \
        gps_pwr.ko \
        ilitek_v3_mmi.ko \
        leds-gpio.ko \
        mmi_info.ko \
        mmi_relay.ko \
        moto_f_mass_storage.ko \
        moto_f_usbnet.ko \
        moto_mm.ko \
        moto_mmap_fault.ko \
        moto_swap.ko \
        qpnp_adaptive_charge.ko \
        sensors_class.ko \
        st54nfc.ko \
        sx937x_sar.ko \
        utags.ko \
        wlan_drv_gen4m_6855.ko \
        wmt_chrdev_wifi.ko \
        wmt_drv.ko)

# Partitions
BOARD_SUPER_PARTITION_SIZE := 7180648448
BOARD_MOTOROLA_DYNAMIC_PARTITIONS_SIZE := 7176454144 # (BOARD_SUPER_PARTITION_SIZE - 4MiB)

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# Security patch level
BOOT_SECURITY_PATCH := 2026-06-01
VENDOR_SECURITY_PATCH := 2026-06-01

# Verified Boot
BOARD_AVB_ROLLBACK_INDEX := 30
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := 30

# Inherit from mt6855-common
include device/motorola/mt6855-common/BoardConfigCommon.mk

# Inherit the proprietary files
include vendor/motorola/cancunn/BoardConfigVendor.mk
