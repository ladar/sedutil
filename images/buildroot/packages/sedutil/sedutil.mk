################################################################################
#
# sedutil
#
################################################################################
SEDUTIL_VERSION = 1.16.0
SEDUTIL_SOURCE = sedutil-$(SEDUTIL_VERSION).tar.gz
SEDUTIL_SITE = https://github.com/ladar/sedutil
SEDUTIL_INSTALL_STAGING = NO
SEDUTIL_LIBTOOL_PATCH = NO
SEDUTIL_INSTALL_TARGET = YES
SEDUTIL_CONF_OPTS = --sbindir=/sbin
SWDUTIL_MAKE=$(MAKE1)
#SEDUTIL_DEPENDENCIES = libstdc++
# Dont regen version header use the tarball version
define SEDUTIL_POST_EXTRACT_ACTIONS
sed -i '/^CLEANFILES/d' $(BUILD_DIR)/sedutil-$(SEDUTIL_VERSION)/Makefile.am
sed -i '/^BUILT_SOURCES/d' $(BUILD_DIR)/sedutil-$(SEDUTIL_VERSION)/Makefile.am
sed -i '/^linux\/Version/,3 d' $(BUILD_DIR)/sedutil-$(SEDUTIL_VERSION)/Makefile.am
sed -i 's/^AM_CXXFLAGS.*/\0 -DPBA_BUILD/' $(BUILD_DIR)/sedutil-$(SEDUTIL_VERSION)/Makefile.am
sed -i '/^BUILT_SOURCES/d' $(BUILD_DIR)/sedutil-$(SEDUTIL_VERSION)/Makefile.in
sed -i '/^CLEANFILES/d' $(BUILD_DIR)/sedutil-$(SEDUTIL_VERSION)/Makefile.in
sed -i '/^linux\/Version/,3 d' $(BUILD_DIR)/sedutil-$(SEDUTIL_VERSION)/Makefile.in
sed -i 's/^AM_CXXFLAGS.*/\0 -DPBA_BUILD/' $(BUILD_DIR)/sedutil-$(SEDUTIL_VERSION)/Makefile.in
endef
SEDUTIL_POST_EXTRACT_HOOKS += SEDUTIL_POST_EXTRACT_ACTIONS
# Use the networked PBA if networking is enabled. Otherwise delete it from build directory.
ifeq ($(BR2_PACKAGE_SEDUTIL_NETWORKING),y)
define SEDUTIL_POST_BUILD_ACTIONS
rm -f $(BUILD_DIR)/sedutil-$(SEDUTIL_VERSION)/linuxpba
mv $(BUILD_DIR)/sedutil-$(SEDUTIL_VERSION)/linuxpba_networked $(BUILD_DIR)/sedutil-$(SEDUTIL_VERSION)/linuxpba
else
define SEDUTIL_POST_BUILD_ACTIONS
rm -f $(BUILD_DIR)/sedutil-$(SEDUTIL_VERSION)/linuxpba_networked
endef
endif
SEDUTIL_POST_BUILD_HOOKS += SEDUTIL_POST_BUILD_ACTIONS
$(eval $(autotools-package))
