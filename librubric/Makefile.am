# --- librubric ---
lib_LTLIBRARIES = librubric.la

librubric_la_SOURCES = \
	assemblyinfo.vala \
	src/application/application.vala \
	src/application/menu-manager.vala \
	src/application/menu-extension.vala \
	src/application/menu-adapter-factory.vala \
	src/application/shell.vala \
	src/application/assistant.vala \
	src/application/assembly.vala \
	src/application/preferences.vala \
	src/collections/iterator.vala \
	src/collections/observable-collection.vala \
	src/collections/observable.vala \
	src/collections/node.vala \
	src/container/container.vala \
	src/container/container-extension.vala \
	src/container/gir-resource-handler.vala \
	src/logging/category.vala \
	src/logging/logger.vala \
	src/logging/debug-logger.vala \
	src/logging/void-logger.vala \
	src/messaging/messenger.vala \
	src/messaging/pub-sub.vala \
	src/messaging/observer.vala \
	src/messaging/observable.vala \
	src/messaging/subscriber.vala \
	src/modularity/module-info.vala \
	src/modularity/module.vala \
	src/modularity/module-catalog.vala \
	src/modularity/module-manager.vala \
	src/modularity/module-catalog-info.vala \
	src/navigation/navigable.vala \
	src/navigation/navigator.vala \
	src/navigation/navigation-service.vala \
	src/navigation/navigation-result.vala \
	src/regions/adapter-factory.vala \
	src/regions/region.vala \
	src/regions/region-adapter.vala \
	src/regions/region-manager.vala \
	src/regions/region-collection.vala \
	src/regions/view-collection.vala \
	src/regions/view-registry.vala \
	src/presentation/view.vala \
	src/presentation/view-model.vala \
	src/presentation/dialog-service.vala \
	src/presentation/file-dialog-settings.vala \
	src/presentation/open-file-dialog-settings.vala \
	src/presentation/save-file-dialog-settings.vala \
	src/serialization/xml-serializer.vala \
	src/serialization/xml-file.vala

librubric_la_VALAFLAGS = \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg libxml-2.0 \
	--pkg gobject-introspection-1.0 \
	--library rubric \
	--shared-library librubric.so \
	--vapi rubric-1.0.vapi \
	--target-glib=2.40.0 \
	--gir=Rubric-1.0.gir \
	--vapi-comments \
	-H rubric.h

if ENABLE_DEVELOPMENT_MODE

librubric_la_VALAFLAGS += \
	-D ENABLE_DEVELOPMENT_MODE \
	-g

endif

librubric_la_LDFLAGS = \
	-shared

librubric_la_LIBADD = \
	$(LIBRUBRIC_LIBS)

librubric_la_CFLAGS = \
	$(LIBRUBRIC_CFLAGS)

librubric_la_includedir = $(includedir)/rubric
librubric_la_include_HEADERS = rubric.h

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = rubric-1.0.pc

# vapis
vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
	rubric-1.0.vapi

CLEANFILES =

-include $(INTROSPECTION_MAKEFILE)
if HAVE_INTROSPECTION

Rubric-1.0.typelib: Rubric-1.0.gir
	g-ir-compiler \
		--shared-library=librubric.so \
		--output=$@ \
		$<

girdir = $(datadir)/gir-1.0
gir_DATA = Rubric-1.0.gir

typelibdir = $(libdir)/girepository-1.0
typelib_DATA = Rubric-1.0.typelib

CLEANFILES += \
	$(gir_DATA) \
	$(typelib_DATA)

endif

CLEANFILES += \
	$(librubric_la_SOURCES:.vala=.c) \
	*.vapi \
	*.h \
	*.pc

MAINTAINERCLEANFILES = \
	$(CLEANFILES)

-include $(top_srcdir)/git.mk
