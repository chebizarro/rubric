CLEANFILES =
DISTCLEANFILES =

include $(top_srcdir)/build/autotools/glib-tap.mk

TESTS_ENVIRONMENT += \
	G_MESSAGES_DEBUG=all \
	G_SLICE=debug-blocks

lib_LTLIBRARIES = libtest-objects.la

libtest_objects_la_SOURCES = \
	embed/assemblyinfo.vala \
	embed/date.vala \
	embed/file-manager.vala \
	embed/product.vala \
	embed/person.vala \
	embed/point-3d.vala \
	embed/base64-encoder.vala \
	embed/predefined-strings.vala \
	embed/simple-singleton.vala \
	embed/temperature.vala \
	embed/drawing/point.vala \
	embed/drawing/color.vala \
	embed/drawing/known-color-table.vala

libtest_objects_la_VALAFLAGS = \
	--header=test-objects.h \
	--library=test-objects \
	--gir=TestObjects-1.0.gir \
	--vapi=test-objects.vapi

libtest_objects_la_CFLAGS = \
	$(TESTS_CFLAGS) \
	-shared \
	-g

libtest_objects_la_LDFLAGS = \
	-rdynamic \
	-shared \
	-export-dynamic


test_programs = test-mujs-1.0

test_mujs_1_0_SOURCES = \
	embed.vala

test_mujs_1_0_sources = \
	mujs.vala \
	es-5.vala

test_mujs_1_0_VALAFLAGS = \
	--library=test-mujs \
	--gir=test-mujs-1.0.gir \
	--pkg valadate-1.0 \
	--pkg rubric-web-1.0 \
	--pkg mujs-1.0 \
	--pkg test-objects \
	--vapidir . \
	--vapidir $(builddir)/../ \
	--vapidir $(top_builddir)/librubric \
	--vapidir $(top_builddir)/librubric-web

test_mujs_1_0_LDADD = \
	$(LIBRUBRIC_WEB_LIBS) \
	$(TESTS_LIBS) \
	./libtest-objects.la \
	$(top_builddir)/librubric/librubric.la \
	$(top_builddir)/librubric-web/librubric-web.la \
	$(builddir)/../libmujs-engine.la

test_mujs_1_0_CPPFLAGS = \
	-fPIE

test_mujs_1_0_CFLAGS = \
	-I$(top_srcdir)/librubric/ \
	-I$(top_srcdir)/librubric-web/ \
	-I$(top_srcdir)/librubric-web/modules/mujs-engine \
	$(LIBRUBRIC_WEB_CFLAGS) \
	$(TESTS_CFLAGS) \
	-shared \
	-pie \
	-g

test_mujs_1_0_LDFLAGS =  \
	-fPIE \
	-rdynamic \
	-shared \
	-export-dynamic

-include $(INTROSPECTION_MAKEFILE)
if HAVE_INTROSPECTION

TestObjects-1.0.typelib: TestObjects-1.0.gir
	g-ir-compiler \
		--includedir=$(datadir)/gir-1.0 \
		--shared-library=.libs/libtest-objects.so.0 \
		--output=$@ \
		$<

libtest_objects_la_girdir = $(datadir)/gir-1.0
libtest_objects_la_gir_DATA = $(srcdir)/TestObjects-1.0.gir

libtest_objects_la_typelibdir = $(libdir)/girepository-1.0
libtest_objects_la_typelib_DATA = TestObjects-1.0.typelib

CLEANFILES += \
	$(libtest_objects_la_typelib_DATA)

GITIGNOREFILES = \
	$(libtest_objects_la_gir_DATA)
	
EXTRA_DIST += \
	$(libtest_objects_la_gir_DATA)
	
MAINTAINERCLEANFILES += \
	$(libtest_objects_la_gir_DATA)

endif

-include $(top_srcdir)/git.mk
