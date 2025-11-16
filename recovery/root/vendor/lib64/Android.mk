LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := android.hardware.security.keymint-V2-ndk.so
LOCAL_MODULE := android.hardware.security.keymint-V2-ndk
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_STEM := android.hardware.security.keymint-V2-ndk
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_LIB64)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := ossi
LOCAL_PREBUILT_MODULE_FILE := $(LOCAL_PATH)/android.hardware.security.keymint-V2-ndk.so
include $(BUILD_PREBUILT)

