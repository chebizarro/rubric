# --- librubric ---
lib_LTLIBRARIES = librubric-gtk.la

librubric_gtk_la_SOURCES = \
	src/application/application.vala \
	src/application/shell.vala \
	src/application/menu-adapter-factory.vala \
	src/container/gtk-builder-resource-handler.vala \
	src/modularity/module-manager.vala \
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
	--girdir=$(top_builddir)/librubric \
	--library rubric-gtk \
	--vapi rubric-gtk-1.0.vapi \
	--target-glib=2.40.0 \
	--gir=RubricGtk-1.0.gir \
	-H rubric-gtk.h

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
	$(LIBRUBRIC_GTK_CFLAGS)

librubric_gtk_la_CPPFLAGS = \
	-I$(top_builddir)/librubric \
	`pkg-config --cflags --libs $(pkg_rubric_modules) gio-2.0` \
	-DRUBRIC_LIB_DIR=\""$(LIBRUBRIC_GTK_LIB_DIR)"\" \
	-include $(CONFIG_HEADER)

librubric_gtk_la_includedir = $(includedir)/rubric
librubric_gtk_la_include_HEADERS = rubric-gtk.h

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = rubric-gtk-1.0.pc

# vapis
vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
	rubric-gtk-1.0.vapi

CLEANFILES =

-include $(INTROSPECTION_MAKEFILE)
if HAVE_INTROSPECTION

RubricGtk-1.0.typelib: RubricGtk-1.0.gir
	g-ir-compiler \
		--shared-library=librubric-gtk.so.0 \
		--output=$@ \
		$<

girdir = $(datadir)/gir-1.0
gir_DATA = RubricGtk-1.0.gir

typelibdir = $(libdir)/girepository-1.0
typelib_DATA = RubricGtk-1.0.typelib

CLEANFILES += \
	$(gir_DATA) \
	$(typelib_DATA)

endif

CLEANFILES += \
	$(librubric_gtk_la_SOURCES:.vala=.c) \
	*.vapi \
	*.h \
	*.pc

MAINTAINERCLEANFILES = \
	$(CLEANFILES)

-include $(top_srcdir)/git.mk
