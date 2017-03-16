include $(top_srcdir)/base.am

ACLOCAL_AMFLAGS  = -I build/autotools ${ACLOCAL_FLAGS}
AUTOMAKE_OPTIONS = subdir-objects

INTLTOOL_FILES = \
	intltool-extract.in \
	intltool-merge.in \
	intltool-update.in

EXTRA_DIST = \
	$(noinst_DATA) \
	$(INTLTOOL_FILES) \
	autogen.sh

CLEANFILES += *.stamp

DISTCLEANFILES += \
	$(INTLTOOL_FILES) \
	po/.intltool-merge-cache

SUBDIRS = \
	build \
	po \
	librubric \
	librubric-gtk \
	tools \
	tests \
	examples

if ENABLE_DOCS
SUBDIRS += docs
endif

include $(top_srcdir)/git.mk
