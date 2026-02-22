Author: dianeasaur <4983626+dianeasaur@users.noreply.github.com>

  Leave MOZ_APP_NAME in place until packaging process begins

--- toolkit/mozapps/installer/packager.mk.orig	2026-02-23 06:25:14 UTC
+++ toolkit/mozapps/installer/packager.mk
@@ -156,6 +156,9 @@ GARBAGE += make-package

 GARBAGE += make-package

+installdir = %%INSTALL_LIBDIR%%
+MOZ_APP_NAME = %%PORTNAME%%
+
 make-sourcestamp-file::
 	$(NSINSTALL) -D $(DIST)/$(PKG_PATH)
 	@awk '$$2 == "MOZ_BUILDID" {print $$3}' $(DEPTH)/buildid.h > $(MOZ_SOURCESTAMP_FILE)
