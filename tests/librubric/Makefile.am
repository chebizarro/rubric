CLEANFILES =
DISTCLEANFILES =
include $(top_srcdir)/build/autotools/glib-tap.mk

schema_file = data/org.rubric.tests.gschema.xml

gsettings_SCHEMAS =	\
	$(schema_file)

@GSETTINGS_RULES@

gschemas.compiled: $(schema_file)
	$(GLIB_COMPILE_SCHEMAS) $(top_srcdir)/tests/librubric/data

all: gschemas.compiled

data/resources.c: $(top_srcdir)/tests/librubric/data/test.gresource.xml $(shell glib-compile-resources --sourcedir=$(top_srcdir)/tests/librubric/data/ --generate-dependencies  $(top_srcdir)/tests/librubric/data/test.gresource.xml)
	$(AM_V_GEN) glib-compile-resources --target=$@ --sourcedir=$(top_srcdir)/tests/librubric/data/ --generate-source $<

BUILT_SOURCES += \
	data/resources.c

TESTS_ENVIRONMENT += \
	G_MESSAGES_DEBUG=all \
	G_SLICE=debug-blocks \
	GSETTINGS_SCHEMA_DIR=$(top_srcdir)/tests/librubric/data/

test_programs = test-librubric-1.0

test_librubric_1_0_SOURCES =  \
	$(BUILT_SOURCES) \
	application/preferences.vala \
	container/test-objects.vala \
	container/container.vala \
	container/gir-resource-handler.vala \
	collections/iterator.vala
	
test_librubric_1_0_VALAFLAGS = \
	-g \
	--library test-librubric \
	--gir test-librubric-1.0.gir \
	--pkg gee-0.8 \
	--pkg libpeas-1.0 \
	--pkg valadate-1.0 \
	--pkg libxml-2.0 \
	--pkg rubric-1.0 \
	--pkg config \
	--vapidir=$(top_builddir)/librubric \
	--vapidir=$(top_builddir)/vapi \
	--gresources $(top_srcdir)/tests/librubric/data/test.gresource.xml

test_librubric_1_0_LDADD = \
	$(LIBRUBRIC_LIBS) \
	$(TESTS_LIBS) \
	$(top_builddir)/librubric/librubric.la

test_librubric_1_0_CPPFLAGS = \
	-fPIE

test_librubric_1_0_CFLAGS = \
	$(LIBRUBRIC_CFLAGS) \
	$(TESTS_CFLAGS) \
	-I$(top_srcdir)/librubric \
	-shared \
	-pie \
	-g

test_librubric_1_0_LDFLAGS =  \
	-fPIE \
	-rdynamic


CLEANFILES += \
	$(test_librubric_1_0_SOURCES:.vala=.c) \
	*.vapi \
	*.gir \
	*.stamp \
	*.stamp-t \
	data/*.c

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
