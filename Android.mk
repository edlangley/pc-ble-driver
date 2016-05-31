LOCAL_PATH := $(ANDROID_BUILD_TOP)/$(call my-dir)

CMAKE := $(shell which cmake) 

LOCAL_MODULE := pc_ble_driver
OUT_DIR := $(ANDROID_PRODUCT_OUT)/obj/STATIC_LIBRARIES/$(LOCAL_MODULE)

ifeq ($CMAKE,)
    $(error CMake not found, will not compile pc_ble_driver)
else
    $(info CMake found, will compile pc_ble_driver)
    PWD_OUTPUT := "$(shell env)"
    $(info LOCAL_PATH=$(LOCAL_PATH))
    CMAKE_OUTPUT := $(shell mkdir $(OUT_DIR) ; cd $(OUT_DIR) ; cmake \
    -DANDROID_NDK=$(ANDROID_BUILD_TOP)/prebuilts/ndk/current \
    -DANDROID_NDK_LAYOUT=ANDROID \
    -DCMAKE_BUILD_TYPE=Release \
    -DANDROID_ABI="armeabi-v7a with NEON" \
    -DSERIALIZATION_VERSION=0.0.0 \
    -DSERIALIZATION_REVISION=0 \
    -DARTIFACT=driver \
    -DNRF51_SDK_PATH=$(ANDROID_BUILD_TOP)/external/nRF51_SDK_8.1.0_b6ed55f/ \
    -DBoost_INCLUDE_DIR=$(ANDROID_BUILD_TOP)/external/boost-for-android/build/include/boost-1_55 \
    -DBOOST_LIBRARYDIR=$(ANDROID_BUILD_TOP)/external/boost-for-android/build/lib \
    -DBOOST_ROOT=$(ANDROID_BUILD_TOP)/external/boost-for-android/build \
    -DBoost_COMPILER="-gcc" \
    -DBoost_DEBUG=ON \
	$(LOCAL_PATH) 2>&1)
    $(info $(CMAKE_OUTPUT))
endif

ifeq ($(TARGET_ARCH),arm)
    -DCMAKE_TOOLCHAIN_FILE=$(LOCAL_PATH)/android.toolchain.cmake \
    TOOLCHAIN := arm-linux-androideabi-4.4.x
endif

ifeq ($(TARGET_ARCH),x86)
    TOOLCHAIN := i686-android-linux-4.4.3
endif

LOCAL_MODULE_TAGS := debug eng

include $(BUILD_STATIC_LIBRARY)


