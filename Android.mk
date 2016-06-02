LOCAL_PATH := $(ANDROID_BUILD_TOP)/$(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := libs120_nrf51_ble_driver
LIB_OUT_DIR := $(LOCAL_PATH)/build
NRF51_SDK_PATH := $(LOCAL_PATH)/nRF51_SDK_8.1.0_b6ed55f

ifeq ($CMAKE,)
    $(error CMake not found, will not compile pc_ble_driver)
else
    $(info CMake found, will compile pc_ble_driver)
    CMAKE_OUTPUT := $(shell mkdir $(LIB_OUT_DIR) ; cd $(LIB_OUT_DIR) ; cmake \
    -DCMAKE_TOOLCHAIN_FILE=$(LOCAL_PATH)/android.toolchain.cmake \
    -DANDROID_NDK=$(ANDROID_BUILD_TOP)/prebuilts/ndk/current \
    -DANDROID_NDK_LAYOUT=ANDROID \
    -DCMAKE_BUILD_TYPE=Release \
    -DANDROID_ABI="armeabi-v7a with NEON" \
	-DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-4.7 \
    -DSERIALIZATION_VERSION=0.0.0 \
    -DSERIALIZATION_REVISION=0 \
    -DARTIFACT=driver \
    -DNRF51_SDK_PATH=$(NRF51_SDK_PATH) \
    -DBoost_INCLUDE_DIR=$(ANDROID_BUILD_TOP)/external/boost-for-android/build/include/boost-1_55 \
    -DBOOST_LIBRARYDIR=$(ANDROID_BUILD_TOP)/external/boost-for-android/build/lib \
    -DBOOST_ROOT=$(ANDROID_BUILD_TOP)/external/boost-for-android/build \
    -DBoost_COMPILER="-gcc" \
    -DBoost_DEBUG=ON \
	$(LOCAL_PATH) 2>&1)
    $(info $(CMAKE_OUTPUT))
	MAKE_OUTPUT := $(shell cd $(LIB_OUT_DIR) && make)
endif

LOCAL_MODULE_TAGS := debug eng
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)/driver/inc $(LOCAL_PATH)/driver/inc_override $(NRF51_SDK_PATH)/components/softdevice/s130/headers
LOCAL_MODULE_TAGS := eng
module_class := SHARED_LIBRARIES
LOCAL_MODULE_CLASS := $(module_class)
LOCAL_MODULE_SUFFIX := .so
LOCAL_SRC_FILES := build/driver/$(LOCAL_MODULE).so
include $(BUILD_PREBUILT)
