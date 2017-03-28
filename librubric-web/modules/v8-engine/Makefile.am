SUBDIRS = . tests

plugin_in_files = v8-engine.plugin.in
%.plugin: %.plugin.in $(INTLTOOL_MERGE) $(wildcard $(top_srcdir)/po/*po) ; $(INTLTOOL_MERGE) $(top_srcdir)/po $< $@ -d -u -c $(top_builddir)/po/.intltool-merge-cache

lib_LTLIBRARIES = libv8-engine.la

libv8_engine_la_LDFLAGS = \
	-no-undefined \
	-shared -fPIC \
	-L/usr/lib

libv8_engine_la_LIBADD = \
	$(LIBRUBRIC_WEB_LIBS) \
	$(top_builddir)/librubric/librubric.la \
	$(top_builddir)/librubric-web/librubric-web.la \
	-lv8_libbase \
	-lv8_libplatform \
	-lv8 \
	-lpthread

libv8_engine_la_SOURCES = \
	v8-engine.h \
	v8-engine.cpp

libv8_engine_la_CXXFLAGS = \
	-g -Og \
	-std=c++11 \
	$(LIBRUBRIC_WEB_CFLAGS) \
	-fpermissive \
	-I$(top_srcdir)/librubric \
	-I$(top_srcdir)/librubric-web \
	`pkg-config --cflags --libs $(pkg_web_modules) gio-2.0` \
	-shared

-include $(INTROSPECTION_MAKEFILE)

if HAVE_INTROSPECTION

INTROSPECTION_GIRS = RubricWebV8-1.0.gir

INTROSPECTION_SCANNER_ARGS = \
	--warn-all \
	--c-include=v8-engine.h \
	--identifier-prefix=RubricWebV8

INTROSPECTION_SCANNER_ENV = \
	CC="$(CC)" \
	PKG_CONFIG_PATH="$(PKG_CONFIG_PATH):$(top_builddir)/librubric-web:$(top_builddir)/librubric"

INTROSPECTION_COMPILER_ARGS = \
	--includedir=$(top_srcdir)/librubric \
	--includedir=$(top_srcdir)/librubric-web

introspection_sources = $(libv8_engine_la_SOURCES)

RubricWebV8-1.0.gir: libv8-engine.la
RubricWebV8_1_0_gir_INCLUDES = RubricWeb-1.0
RubricWebV8_1_0_gir_CFLAGS = $(LIBRUBRIC_WEB_CFLAGS) -I$(srcdir) -I$(top_srcdir)/librubric-web -I$(top_srcdir)/librubric
#RubricWebV8_1_0_gir_LDFLAGS =
#RubricWebV8_1_0_gir_PACKAGES = 
RubricWebV8_1_0_gir_LIBS = libv8-engine.la
RubricWebV8_1_0_gir_FILES = $(introspection_sources)
RubricWebV8_1_0_gir_NAMESPACE = RubricWebV8
RubricWebV8_1_0_gir_SCANNERFLAGS = \
	--add-include-path=$(top_srcdir)/librubric \
	--add-include-path=$(top_srcdir)/librubric-web

girdir = $(datadir)/gir-1.0
gir_DATA = $(INTROSPECTION_GIRS)

typelibdir = $(libdir)/girepository-1.0
typelib_DATA = $(INTROSPECTION_GIRS:.gir=.typelib)

#CLEANFILES += $(gir_DATA) $(typelib_DATA)
endif

if ENABLE_VAPIGEN
-include $(VAPIGEN_MAKEFILE)

rubric-web-v8-1.0.vapi: libv8-engine.la

VAPIGEN_VAPIS = rubric-web-v8-1.0.vapi

rubric_web_v8_1_0_vapi_DEPS = rubric-1.0 rubric-web-1.0 $(pkg_web_modules)
rubric_web_v8_1_0_vapi_METADATADIRS = $(srcdir)
rubric_web_v8_1_0_vapi_VAPIDIRS = $(top_srcdir)/librubric-web $(top_srcdir)/librubric
rubric_web_v8_1_0_vapi_GIRDIRS = $(top_srcdir)/librubric-web $(top_srcdir)/librubric
rubric_web_v8_1_0_vapi_FILES = RubricWebV8-1.0.gir
rubric_web_v8_1_0_vapi_LIBRARY = rubric-web-v8-1.0

vapidir = $(datadir)/vala/vapi
vapi_DATA = $(VAPIGEN_VAPIS) 
# $(VAPIGEN_VAPIS:.vapi=.deps)

#CLEANFILES += $(vapi_DATA)
endif

EXTRA_DIST = \
	$(plugin_in_files) \
	$(VAPIGEN_VAPIS)

-include $(top_srcdir)/git.mk
