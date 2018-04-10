SUBDIRS = . modules

lib_LTLIBRARIES = librubric-web.la

librubric_web_la_SOURCES = \
	assemblyinfo.vala \
	src/application/application.vala \
	src/application/shell.vala \
	src/js/engine.vala \
	src/js/base-engine.vala \
	src/js/base-engine-set-property.c \
	src/regions/region-manager.vala \
	src/regions/view-registry.vala \
	src/presentation/base-view.vala \
	src/presentation/html-view.vala
	
librubric_web_la_VALAFLAGS = \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg libxml-2.0 \
	--pkg libpeas-1.0 \
	--pkg rubric-1.0 \
	--pkg valum-0.4 \
	--vapidir=$(top_builddir)/librubric \
	--girdir=$(top_builddir)/librubric \
	--library rubric-web-1.0 \
	--vapi rubric-web-1.0.vapi \
	--target-glib=2.40.0 \
	--gir=RubricWeb-1.0.gir \
	-H rubric-web.h

if ENABLE_DEVELOPMENT_MODE

librubric_web_la_VALAFLAGS += \
	-D ENABLE_DEVELOPMENT_MODE \
	-g

endif

librubric_web_la_LDFLAGS = \
	-shared \
	-export-dynamic

librubric_web_la_LIBADD = \
	$(LIBRUBRIC_WEB_LIBS) \
	$(top_builddir)/librubric/librubric.la
	

librubric_web_la_CFLAGS = \
	-I$(top_builddir)/librubric \
	-I$(top_srcdir)/librubric \
	$(LIBRUBRIC_WEB_CFLAGS)

librubric_web_la_CPPFLAGS = \
	`pkg-config --cflags --libs $(pkg_rubric_modules) gio-2.0` \
	-DRUBRIC_LIB_DIR=\""$(LIBRUBRIC_WEB_LIB_DIR)"\" \
	-include $(CONFIG_HEADER)

librubric_web_la_headerdir = $(includedir)/rubric
librubric_web_la_header_HEADERS = rubric-web.h

librubric_web_la_pkgconfigdir = $(libdir)/pkgconfig
librubric_web_la_pkgconfig_DATA = rubric-web-1.0.pc

librubric_web_la_vapidir = $(datadir)/vala/vapi
librubric_web_la_vapi_DATA = rubric-web-1.0.vapi rubric-web-1.0.deps

MAINTAINERCLEANFILES = \
	rubric-web-1.0.vapi \
	$(librubric_web_la_pkgconfig_DATA) \
	$(librubric_web_la_header_HEADERS) \
	$(librubric_web_la_SOURCES:.vala=.c)
	
EXTRA_DIST = \
	$(librubric_web_la_header_HEADERS) \
	$(librubric_web_la_vapi_DATA)
	
DISTCLEANFILES = \
	$(librubric_web_la_pkgconfig_DATA)


-include $(INTROSPECTION_MAKEFILE)
if HAVE_INTROSPECTION

RubricWeb-1.0.typelib: RubricWeb-1.0.gir
	g-ir-compiler \
		--includedir=$(datadir)/gir-1.0 \
		--includedir=$(top_srcdir)/librubric \
		--shared-library=librubric-web.so.0 \
		--output=$@ \
		$<

librubric_web_la_girdir = $(datadir)/gir-1.0
librubric_web_la_gir_DATA = $(srcdir)/RubricWeb-1.0.gir

librubric_web_la_typelibdir = $(libdir)/girepository-1.0
librubric_web_la_typelib_DATA = RubricWeb-1.0.typelib

CLEANFILES = \
	$(librubric_web_la_typelib_DATA)

GITIGNOREFILES = \
	$(librubric_web_la_gir_DATA)
	
EXTRA_DIST += \
	$(librubric_web_la_gir_DATA)
	
MAINTAINERCLEANFILES += \
	$(librubric_web_la_gir_DATA)

endif

-include $(top_srcdir)/git.mk
