GLADE_GEN = $(top_builddir)/tools/glade-catalogger

GLADE_FILES = stock-glade-catalog.xml

plugin_in_files = stock.plugin.in
%.plugin: %.plugin.in $(INTLTOOL_MERGE) $(wildcard $(top_srcdir)/po/*po) ; $(INTLTOOL_MERGE) $(top_srcdir)/po $< $@ -d -u -c $(top_builddir)/po/.intltool-merge-cache

resources.c: module.gresource.xml $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir=$(top_srcdir)/examples/tienda/modules/stock/ $(top_srcdir)/examples/tienda/modules/stock/module.gresource.xml)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/examples/tienda/modules/stock/ --generate-source $<

stock_moduledir = $(datadir)/tienda/modules/stock
dist_stock_module_DATA = $(plugin_in_files:.plugin.in=.plugin)

plugindir = $(datadir)/tienda/modules/stock
plugin_LTLIBRARIES = libstock.la

libstock_la_LIBADD = \
	$(LIBRUBRIC_GTK_LIBS) \
	$(top_builddir)/librubric/librubric.la \
	$(top_builddir)/librubric-gtk/librubric-gtk.la

libstock_la_SOURCES = \
	resources.c \
	module.vala \
	views/catalog-view.vala \
	views/category-treestore.vala

libstock_la_CFLAGS = \
	$(LIBRUBRIC_GTK_CFLAGS) \
	-I$(top_srcdir)/librubric \
	-I$(top_srcdir)/librubric-gtk \
	`pkg-config --cflags --libs $(pkg_gtk_modules) gio-2.0 gom-1.0 sqlite3` \
	-shared

libstock_la_VALAFLAGS = \
	--gresources module.gresource.xml \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg libxml-2.0 \
	--pkg gtk+-3.0 \
	--pkg libpeas-1.0 \
	--pkg rubric-1.0 \
	--pkg rubric-gtk-1.0 \
	--pkg gom-1.0 \
	--pkg sqlite3 \
	--vapidir=$(top_builddir)/librubric \
	--vapidir=$(top_builddir)/librubric-gtk \
	--vapidir=$(top_builddir)/vapi \
	--target-glib=2.40.0 \
	--library stock \
	--vapi stock-1.0.vapi \
	--gir=Stock-1.0.gir \
	-g

stock-glade-catalog.xml: $(top_srcdir)/examples/tienda/modules/stock/Stock-1.0.gir
	$(GLADE_GEN) $<
	
CLEANFILES = \
	$(libstock_la_SOURCES:.vala=.c) \
	$(GLADE_FILES) \
	*.plugin \
	*.h \
	*.gir \
	*.vapi \
	*.stamp

EXTRA_DIST = \
	$(plugin_in_files)	

noinst_DATA = \
	$(GLADE_FILES) \
	module.gresource.xml
	
-include $(top_srcdir)/git.mk
