ARCHS = armv7 arm64

THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222
THEOS_PACKAGE_DIR_NAME = debs
ADDITIONAL_OBJCFLAGS = -fobjc-arc
GO_EASY_ON_ME = 1
include theos/makefiles/common.mk

TWEAK_NAME = GreyScale
GreyScale_FILES = Tweak.xm WVImageController.m
GreyScale_FRAMEWORKS = UIKit CoreGraphics QuartzCore CoreImage
GreyScale_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += greyscale
include $(THEOS_MAKE_PATH)/aggregate.mk
