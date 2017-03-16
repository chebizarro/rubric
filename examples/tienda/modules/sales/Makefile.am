GLADE_GEN = $(top_srcdir)/tools/glade-catalogger

GLADE_FILES = sales-glade-catalog.xml

plugin_in_files = sales.plugin.in
%.plugin: %.plugin.in $(INTLTOOL_MERGE) $(wildcard $(top_srcdir)/po/*po) ; $(INTLTOOL_MERGE) $(top_srcdir)/po $< $@ -d -u -c $(top_builddir)/po/.intltool-merge-cache

resources.c: module.gresource.xml $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir=$(top_srcdir)/examples/tienda/modules/sales/ $(top_srcdir)/examples/tienda/modules/sales/module.gresource.xml)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/examples/tienda/modules/sales/ --generate-source $<

sales_moduledir = $(datadir)/tienda/modules/sales
dist_sales_module_DATA = $(plugin_in_files:.plugin.in=.plugin)

plugindir = $(datadir)/tienda/modules/sales
plugin_LTLIBRARIES = libsales.la

libsales_la_LIBADD = \
	$(LIBRUBRIC_GTK_LIBS) \
	$(top_builddir)/librubric/librubric.la \
	$(top_builddir)/librubric-gtk/librubric-gtk.la

libsales_la_SOURCES = \
	resources.c \
	module.vala \
	views/order-view.vala

libsales_la_CFLAGS = \
	$(LIBRUBRIC_GTK_CFLAGS) \
	-I$(top_builddir)/librubric \
	-I$(top_builddir)/librubric-gtk \
	`pkg-config --cflags --libs $(pkg_gtk_modules) gio-2.0 gom-1.0 sqlite3` \
	-shared

libsales_la_VALAFLAGS = \
	--gresources $(top_srcdir)/examples/tienda/modules/sales/module.gresource.xml \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg libxml-2.0 \
	--pkg gtk+-3.0 \
	--pkg libpeas-1.0 \
	--pkg rubric-1.0 \
	--pkg rubric-gtk-1.0 \
	--pkg gom-1.0 \
	--pkg sqlite3 \
	--vapidir=$(top_srcdir)/librubric \
	--vapidir=$(top_srcdir)/librubric-gtk \
	--vapidir=$(top_srcdir)/vapi \
	--target-glib=2.40.0 \
	--library sales \
	--vapi sales-1.0.vapi \
	--gir=Sales-1.0.gir \
	-g

sales-glade-catalog.xml: Sales-1.0.gir
	$(GLADE_GEN) $<
	
CLEANFILES = \
	$(libsales_la_SOURCES:.vala=.c) \
	sales.plugin \
	Sales-1.0.gir \
	sales-1.0.vapi \
	$(GLADE_FILES)

EXTRA_DIST = \
	$(plugin_in_files)	

noinst_DATA = \
	$(GLADE_FILES) \
	module.gresource.xml
	
-include $(top_srcdir)/git.mk
