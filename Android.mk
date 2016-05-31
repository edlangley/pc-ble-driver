LOCAL_PATH := $(ANDROID_BUILD_TOP)/$(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := pc-ble-driver
LIB_OUT_DIR := $(ANDROID_PRODUCT_OUT)/obj/STATIC_LIBRARIES/$(LOCAL_MODULE)
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
endif

LOCAL_MODULE_TAGS := debug eng
LOCAL_SHARED_LIBRARIES := boost_system
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)/driver/inc $(LOCAL_PATH)/driver/inc_override $(NRF51_SDK_PATH)/components/softdevice/s130/headers

include $(BUILD_STATIC_LIBRARY)

all_modules:
	echo TESTS
	cd $(LIB_OUT_DIR) && make
	cp $(LIB_OUT_DIR)/driver/libs130_nrf51_ble_driver.a $(LIB_OUT_DIR)_intermediates/$(LOCAL_MODULE).a
