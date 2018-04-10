SUBDIRS = . tests

plugin_in_files = gecko_engine.plugin.in
%.plugin: %.plugin.in $(INTLTOOL_MERGE) $(wildcard $(top_srcdir)/po/*po) ; $(INTLTOOL_MERGE) $(top_srcdir)/po $< $@ -d -u -c $(top_builddir)/po/.intltool-merge-cache

lib_LTLIBRARIES = libgecko-engine.la

libgecko_engine_la_LDFLAGS = \
	-no-undefined \
	-shared -fPIC \
	-L/usr/lib

libgecko_engine_la_LIBADD = \
	$(LIBRUBRIC_WEB_LIBS) \
	$(top_builddir)/librubric/librubric.la \
	$(top_builddir)/librubric-web/librubric-web.la \
	-lv8_libbase \
	-lv8_libplatform \
	-lv8 \
	-lpthread

libgecko_engine_la_SOURCES = \
	gecko-engine.h \
	gecko-engine.cpp

libgecko_engine_la_CXXFLAGS = \
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

INTROSPECTION_GIRS = GeckoEngine-1.0.gir

INTROSPECTION_SCANNER_ARGS = \
	--warn-all \
	--c-include=gecko_engine.h \
	--identifier-prefix=GeckoEngine

INTROSPECTION_SCANNER_ENV = \
	CC="$(CC)" \
	PKG_CONFIG_PATH="$(PKG_CONFIG_PATH):$(top_builddir)/librubric-web:$(top_builddir)/librubric"

INTROSPECTION_COMPILER_ARGS = \
	--includedir=$(top_srcdir)/librubric \
	--includedir=$(top_srcdir)/librubric-web

introspection_sources = $(libgecko_engine_la_SOURCES)

GeckoEngine-1.0.gir: libgecko-engine.la
GeckoEngine_1_0_gir_INCLUDES = RubricWeb-1.0
GeckoEngine_1_0_gir_CFLAGS = $(LIBRUBRIC_WEB_CFLAGS) -I$(srcdir) -I$(top_srcdir)/librubric-web -I$(top_srcdir)/librubric
#GeckoEngine_1_0_gir_LDFLAGS =
#GeckoEngine_1_0_gir_PACKAGES = 
GeckoEngine_1_0_gir_LIBS = libgecko-engine.la
GeckoEngine_1_0_gir_FILES = $(introspection_sources)
GeckoEngine_1_0_gir_NAMESPACE = GeckoEngine
GeckoEngine_1_0_gir_SCANNERFLAGS = \
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

gecko-engine.vapi: libgecko-engine.la

VAPIGEN_VAPIS = gecko-engine.vapi

rubric_web_v8_1_0_vapi_DEPS = rubric-1.0 rubric-web-1.0 $(pkg_web_modules)
rubric_web_v8_1_0_vapi_METADATADIRS = $(srcdir)
rubric_web_v8_1_0_vapi_VAPIDIRS = $(top_srcdir)/librubric-web $(top_srcdir)/librubric
rubric_web_v8_1_0_vapi_GIRDIRS = $(top_srcdir)/librubric-web $(top_srcdir)/librubric
rubric_web_v8_1_0_vapi_FILES = GeckoEngine-1.0.gir
rubric_web_v8_1_0_vapi_LIBRARY = gecko-engine

vapidir = $(datadir)/vala/vapi
vapi_DATA = $(VAPIGEN_VAPIS) 
# $(VAPIGEN_VAPIS:.vapi=.deps)

#CLEANFILES += $(vapi_DATA)
endif

EXTRA_DIST = \
	$(plugin_in_files) \
	$(VAPIGEN_VAPIS)

-include $(top_srcdir)/git.mk
