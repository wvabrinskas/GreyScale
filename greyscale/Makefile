ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = GreyScale
GreyScale_FILES = GreyScale.mm
GreyScale_INSTALL_PATH = /Library/PreferenceBundles
GreyScale_FRAMEWORKS = UIKit
GreyScale_PRIVATE_FRAMEWORKS = Preferences
GreyScale_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/GreyScale.plist$(ECHO_END)
