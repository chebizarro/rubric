include $(top_srcdir)/base.am

ACLOCAL_AMFLAGS  = -I build/autotools ${ACLOCAL_FLAGS}
AUTOMAKE_OPTIONS = subdir-objects

INTLTOOL_FILES = \
	intltool-extract.in \
	intltool-merge.in \
	intltool-update.in

DISTCLEANFILES = \
	$(INTLTOOL_FILES)
		
EXTRA_DIST = \
	autogen.sh

GITIGNOREFILES = \
	autom4te.cache \
	aclocal.m4 \
	ar-lib \
	build/autotools/intltool.m4 \
	build/autotools/libtool.m4 \
	build/autotools/ltoptions.m4 \
	build/autotools/ltsugar.m4 \
	build/autotools/ltversion.m4 \
	build/autotools/lt~obsolete.m4 \
	compile \
	config.guess \
	config.sub \
	depcomp \
	ltmain.sh \
	missing

MAINTAINERCLEANFILES += \
	$(INTLTOOL_FILES)

SUBDIRS = \
	build \
	po \
	librubric \
	librubric-gtk \
	librubric-web \
	tools \
	tests \
	examples

if ENABLE_DOCS
SUBDIRS += docs
endif

-include $(top_srcdir)/git.mk
