CLEANFILES =
DISTCLEANFILES =

include $(top_srcdir)/build/autotools/glib-tap.mk


data/resources.c: data/test.gresource.xml $(shell glib-compile-resources --sourcedir=$(top_srcdir)/tests/librubric/data/ --generate-dependencies data/test.gresource.xml)
	$(AM_V_GEN) glib-compile-resources --target=$@ --sourcedir=$(top_srcdir)/tests/librubric/data/ --generate-source $<

BUILT_SOURCES += \
	data/resources.c

TESTS_ENVIRONMENT += \
	G_MESSAGES_DEBUG=all \
	G_SLICE=debug-blocks

test_programs = test-librubric-1.0

test_librubric_1_0_SOURCES =  \
	$(BUILT_SOURCES) \
	container/test-objects.vala \
	container/container.vala \
	container/gir-resource-handler.vala \
	collections/iterator.vala
	
test_librubric_1_0_VALAFLAGS = \
	-g \
	--library test-librubric \
	--gir test-librubric-1.0.gir \
	--pkg gee-0.8 \
	--pkg valadate-1.0 \
	--pkg libxml-2.0 \
	--pkg rubric-1.0 \
	--pkg config \
	--vapidir=$(top_builddir)/librubric \
	--vapidir=$(top_builddir)/vapi \
	--gresources data/test.gresource.xml

test_librubric_1_0_LDADD = \
	$(LIBRUBRIC_LIBS) \
	$(TESTS_LIBS) \
	$(top_builddir)/librubric/librubric.la

test_librubric_1_0_CPPFLAGS = \
	-fPIE

test_librubric_1_0_CFLAGS = \
	$(LIBRUBRIC_CFLAGS) \
	$(TESTS_CFLAGS) \
	-I$(top_builddir)/librubric \
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
	data/*.c

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
