SUBDIRS = . data modules

data/resources.c: data/tienda.gresource.xml $(shell glib-compile-resources --sourcedir=$(top_srcdir)/examples/tienda/data/ --generate-dependencies data/tienda.gresource.xml)
	$(AM_V_GEN) glib-compile-resources --target=$@ --sourcedir=$(top_srcdir)/examples/tienda/data/ --generate-source $<

BUILT_SOURCES = \
	data/resources.c

bin_PROGRAMS = tienda

tienda_SOURCES = \
	$(BUILT_SOURCES) \
	src/main.vala
	
tienda_VALAFLAGS = \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg libxml-2.0 \
	--pkg gtk+-3.0 \
	--pkg libpeas-1.0 \
	--pkg rubric-1.0 \
	--pkg rubric-gtk-1.0 \
	--pkg gom-1.0 \
	--gresources data/tienda.gresource.xml \
	--vapidir=$(top_srcdir)/librubric \
	--vapidir=$(top_srcdir)/librubric-gtk \
	--vapidir=$(top_srcdir)/vapi \
	--target-glib=2.40.0 \
	-g

if ENABLE_DEVELOPMENT_MODE

tienda_VALAFLAGS += \
	-D ENABLE_DEVELOPMENT_MODE

endif


tienda_LDADD = \
	$(LIBRUBRIC_GTK_LIBS) \
	$(top_builddir)/librubric/librubric.la \
	$(top_builddir)/librubric-gtk/librubric-gtk.la
	
tienda_CFLAGS = \
	$(LIBRUBRIC_GTK_CFLAGS) \
	-I$(top_builddir)/librubric \
	-I$(top_builddir)/librubric-gtk \
	-I$(top_builddir)/librubric-gom \
	`pkg-config --cflags --libs $(pkg_gtk_modules) gio-2.0 gom-1.0`

CLEANFILES = \
	$(tienda_SOURCES:.vala=.c) \
	$(BUILT_SOURCES)
