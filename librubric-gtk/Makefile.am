lib_LTLIBRARIES = librubric-gtk.la

librubric_gtk_la_SOURCES = \
	assemblyinfo.vala \
	src/application/application.vala \
	src/application/shell.vala \
	src/application/menu-adapter-factory.vala \
	src/container/gtk-builder-resource-handler.vala \
	src/presentation/view-model.vala \
	src/presentation/base-view.vala \
	src/presentation/gtk-dialog-service.vala \
	src/presentation/container-view.vala \
	src/regions/region-manager.vala \
	src/regions/container-adapter.vala \
	src/regions/stack-adapter.vala \
	src/regions/adapter-factory.vala \
	src/regions/view-registry.vala \
	src/widgets/box-view.vala \
	src/widgets/list-treestore.vala \
	src/widgets/liststore.vala \
	src/widgets/node-treestore.vala

librubric_gtk_la_VALAFLAGS = \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg libxml-2.0 \
	--pkg gtk+-3.0 \
	--pkg libpeas-1.0 \
	--pkg libpeas-gtk-1.0 \
	--pkg rubric-1.0 \
	--vapidir=$(top_builddir)/librubric \
	--girdir=$(top_srcddir)/librubric \
	--library=rubric-gtk \
	--vapi=rubric-gtk-1.0.vapi \
	--target-glib=2.40.0 \
	--gir=RubricGtk-1.0.gir \
	--header=rubric-gtk.h

if ENABLE_DEVELOPMENT_MODE

librubric_gtk_la_VALAFLAGS += \
	-D ENABLE_DEVELOPMENT_MODE \
	-g

endif

librubric_gtk_la_LDFLAGS = \
	-shared \
	-export-dynamic

librubric_gtk_la_LIBADD = \
	$(LIBRUBRIC_GTK_LIBS) \
	$(top_builddir)/librubric/librubric.la
	

librubric_gtk_la_CFLAGS = \
	-I$(top_srcdir)/librubric \
	$(LIBRUBRIC_GTK_CFLAGS)

librubric_gtk_la_CPPFLAGS = \
	`pkg-config --cflags --libs $(pkg_gtk_modules) gio-2.0` \
	-DRUBRIC_LIB_DIR=\""$(LIBRUBRIC_GTK_LIB_DIR)"\" \
	-include $(CONFIG_HEADER)

librubric_gtk_la_headerdir = $(includedir)/rubric
librubric_gtk_la_header_HEADERS = $(srcdir)/rubric-gtk.h

librubric_gtk_la_pkgconfigdir = $(libdir)/pkgconfig
librubric_gtk_la_pkgconfig_DATA = rubric-gtk-1.0.pc

librubric_gtk_la_vapidir = $(datadir)/vala/vapi
librubric_gtk_la_vapi_DATA = $(srcdir)/rubric-gtk-1.0.vapi

MAINTAINERCLEANFILES = \
	$(librubric_gtk_la_pkgconfig_DATA) \
	$(librubric_gtk_la_header_HEADERS) \
	$(librubric_gtk_la_vapi_DATA) \
	$(librubric_gtk_la_SOURCES:.vala=.c)

EXTRA_DIST = \
	$(librubric_gtk_la_vapi_DATA) \
	$(librubric_gtk_la_header_HEADERS)
	
DISTCLEANFILES = \
	$(librubric_gtk_la_pkgconfig_DATA)

-include $(INTROSPECTION_MAKEFILE)
if HAVE_INTROSPECTION

RubricGtk-1.0.typelib: RubricGtk-1.0.gir
	g-ir-compiler \
		--includedir=$(top_srcdir)/librubric \
		--shared-library=librubric-gtk.so.0 \
		--output=$@ \
		$<

librubric_gtk_la_girdir = $(datadir)/gir-1.0
librubric_gtk_la_gir_DATA = $(srcdir)/RubricGtk-1.0.gir

librubric_gtk_la_typelibdir = $(libdir)/girepository-1.0
librubric_gtk_la_typelib_DATA = RubricGtk-1.0.typelib

CLEANFILES = \
	$(librubric_gtk_la_typelib_DATA)

GITIGNOREFILES = \
	$(librubric_gtk_la_gir_DATA)

EXTRA_DIST += \
	$(librubric_gtk_la_gir_DATA) \
	$(librubric_gtk_la_pkgconfig_DATA)

MAINTAINERCLEANFILES += \
	$(EXTRA_DIST)

endif

-include $(top_srcdir)/git.mk
