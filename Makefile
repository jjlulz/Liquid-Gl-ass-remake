export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:12.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CC26
CC26_FILES = Tweak.xm
CC26_CFLAGS = -fobjc-arc
CC26_FRAMEWORKS = UIKit QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk
