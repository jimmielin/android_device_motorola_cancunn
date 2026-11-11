#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
# Not core_64_bit_only: the MT6855 vendor runs 32-bit daemons (ccci_fsd, vpud, VoLTE)
# that need the 32-bit runtime.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from device makefile.
$(call inherit-product, device/motorola/cancunn/device.mk)

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

TARGET_BOOT_ANIMATION_RES := 1080

PRODUCT_NAME := lineage_cancunn
PRODUCT_DEVICE := cancunn
PRODUCT_MANUFACTURER := motorola
PRODUCT_BRAND := motorola
PRODUCT_MODEL := moto g power 5G - 2024

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    DeviceName=cancunn \
    BuildDesc="cancunn_g_sys-user 15 V1UDS35H.26-14-6-2-9 a660a-e77c3d release-keys" \
    BuildFingerprint=motorola/cancunn_g_sys/cancunn:15/V1UDS35H.26-14-6-2-9/a660a-e77c3d:user/release-keys
