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
	src/collections/node.vala \
	src/container/container.vala \
	src/container/container-extension.vala \
	src/container/gir-resource-handler.vala \
	src/container/preferences-decorator.vala \
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
	src/modularity/base-module.vala \
	src/modularity/rubric-module-manager.vala \
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
	--pkg gmodule-2.0 \
	--pkg libxml-2.0 \
	--pkg libpeas-1.0 \
	--pkg gobject-introspection-1.0 \
	--library=rubric-1.0 \
	--shared-library=librubric.so \
	--vapi=rubric-1.0.vapi \
	--target-glib=2.40.0 \
	--gir=Rubric-1.0.gir \
	--vapi-comments \
	--header=rubric.h

if ENABLE_DEVELOPMENT_MODE

librubric_la_VALAFLAGS += \
	-D ENABLE_DEVELOPMENT_MODE \
	-g

endif

librubric_la_LDFLAGS = \
	-shared \
	-export-dynamic

librubric_la_LIBADD = \
	$(LIBRUBRIC_LIBS)

librubric_la_CFLAGS = \
	$(LIBRUBRIC_CFLAGS)

librubric_la_headerdir = $(includedir)/rubric
librubric_la_header_HEADERS = $(srcdir)/rubric.h

librubric_la_pkgconfigdir = $(libdir)/pkgconfig
librubric_la_pkgconfig_DATA = rubric-1.0.pc

librubric_la_vapidir = $(prefix)/share/vala/vapi
librubric_la_vapi_DATA = $(srcdir)/rubric-1.0.vapi

MAINTAINERCLEANFILES = \
	$(librubric_la_pkgconfig_DATA) \
	$(librubric_la_header_HEADERS) \
	$(librubric_la_vapi_DATA)

EXTRA_DIST = \
	$(librubric_la_vapi_DATA) \
	$(librubric_la_header_HEADERS)

DISTCLEANFILES = \
 	$(librubric_la_pkgconfig_DATA)

-include $(INTROSPECTION_MAKEFILE)
if HAVE_INTROSPECTION

Rubric-1.0.typelib: Rubric-1.0.gir
	g-ir-compiler \
		--includedir=$(top_builddir)/librubric \
		--shared-library=librubric.so \
		--output=$@ \
		$<

librubric_la_girdir = $(datadir)/gir-1.0
librubric_la_gir_DATA = $(srcdir)/Rubric-1.0.gir

librubric_la_typelibdir = $(libdir)/girepository-1.0
librubric_la_typelib_DATA = Rubric-1.0.typelib

CLEANFILES = $(librubric_la_typelib_DATA)

GITIGNOREFILES = $(librubric_la_gir_DATA)

EXTRA_DIST += \
	$(librubric_la_gir_DATA)

MAINTAINERCLEANFILES += \
	$(librubric_la_gir_DATA) \
	$(librubric_la_pkgconfig_DATA)

endif

-include $(top_srcdir)/git.mk
