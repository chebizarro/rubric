# --- librubric ---
lib_LTLIBRARIES = librubric-orm.la

librubric_orm_la_SOURCES = \
	src/orm-adapter.vala \
	src/orm-repository.vala \
	src/orm-command-builder.vala \
	src/orm-resource-collection.vala \
	src/orm-resource.vala \
	adapters/sqlite/sqlite-adapter.vala \
	adapters/sqlite/sqlite-command-builder.vala

librubric_orm_la_VALAFLAGS = \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg libxml-2.0 \
	--pkg rubric-1.0 \
	--pkg sqlite3 \
	--vapidir=$(top_builddir)/librubric \
	--girdir=$(top_builddir)/librubric \
	--library rubric-orm \
	--vapi rubric-orm-1.0.vapi \
	--target-glib=2.40.0 \
	--gir=RubricOrm-1.0.gir \
	-H rubric-orm.h

if ENABLE_DEVELOPMENT_MODE

librubric_orm_la_VALAFLAGS += \
	-D ENABLE_DEVELOPMENT_MODE \
	-g

endif

librubric_orm_la_LDFLAGS = \
	-shared \
	-export-dynamic

librubric_orm_la_LIBADD = \
	$(LIBRUBRIC_LIBS) \
	$(top_builddir)/librubric/librubric.la
	
librubric_orm_la_CFLAGS = \
	$(LIBRUBRIC_CFLAGS) \
	-I$(top_builddir)/librubric \
	`pkg-config --cflags --libs $(pkg_rubric_modules) gio-2.0 sqlite3` \
	-DRUBRIC_LIB_DIR=\""$(LIBRUBRIC_GTK_LIB_DIR)"\" \
	-include $(CONFIG_HEADER)

librubric_orm_la_includedir = $(includedir)/rubric
librubric_orm_la_include_HEADERS = rubric-orm.h

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = rubric-orm-1.0.pc

# vapis
vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
	rubric-orm-1.0.vapi

CLEANFILES =

-include $(INTROSPECTION_MAKEFILE)
if HAVE_INTROSPECTION

RubricOrm-1.0.typelib:
	g-ir-compiler \
		--shared-library=librubric-orm.so.0 \
		--output=RubricOrm-1.0.typelib \
		RubricOrm-1.0.gir

girdir = $(datadir)/gir-1.0
gir_DATA = RubricOrm-1.0.gir

typelibdir = $(libdir)/girepository-1.0
typelib_DATA = RubricOrm-1.0.typelib

CLEANFILES += \
	$(gir_DATA) \
	$(typelib_DATA)

endif

CLEANFILES += \
	$(librubric_orm_la_SOURCES:.vala=.c) \
	*.vapi \
	*.h \
	*.pc \
	*.stamp

MAINTAINERCLEANFILES = \
	$(CLEANFILES)

-include $(top_srcdir)/git.mk
