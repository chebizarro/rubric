CLEANFILES =
DISTCLEANFILES =
include $(top_srcdir)/build/autotools/glib-tap.mk

data/resources.c: $(srcdir)/data/test.gresource.xml $(shell glib-compile-resources --sourcedir=$(srcdir)/data/ --generate-dependencies  $(srcdir)/data/test.gresource.xml)
	$(AM_V_GEN) glib-compile-resources --target=$@ --sourcedir=$(srcdir)/data/ --generate-source $<

BUILT_SOURCES += \
	data/resources.c

TESTS_ENVIRONMENT += \
	G_MESSAGES_DEBUG=all \
	G_SLICE=debug-blocks \
	GSETTINGS_SCHEMA_DIR=$(srcdir)/data/

test_programs = test-librubric-web-1.0

test_librubric_web_1_0_SOURCES =  \
	$(BUILT_SOURCES)
	
	
test_librubric_web_1_0_VALAFLAGS = \
	-g \
	--library test-librubric \
	--gir test-librubric-web-1.0.gir \
	--pkg rubric-web-1.0 \
	--pkg config \
	--vapidir=$(top_builddir)/librubric \
	--vapidir=$(top_builddir)/librubric-web \
	--vapidir=$(top_builddir)/vapi \
	--gresources $(srcdir)/data/test.gresource.xml

test_librubric_web_1_0_LDADD = \
	$(LIBRUBRIC_LIBS) \
	$(TESTS_LIBS) \
	$(top_builddir)/librubric/librubric.la

test_librubric_web_1_0_CPPFLAGS = \
	-fPIE

test_librubric_web_1_0_CFLAGS = \
	$(LIBRUBRIC_CFLAGS) \
	$(TESTS_CFLAGS) \
	-I$(top_srcdir)/librubric \
	-shared \
	-pie \
	-g

test_librubric_web_1_0_LDFLAGS =  \
	-fPIE \
	-rdynamic


CLEANFILES += \
	$(test_librubric_web_1_0_SOURCES:.vala=.c) \
	*.vapi \
	*.gir \
	*.stamp \
	*.stamp-t \
	data/*.c

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
