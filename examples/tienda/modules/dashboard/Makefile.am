GLADE_GEN = $(top_srcdir)/tools/glade-catalogger

GLADE_FILES = dashboard-glade-catalog.xml

plugin_in_files = dashboard.plugin.in
%.plugin: %.plugin.in $(INTLTOOL_MERGE) $(wildcard $(top_srcdir)/po/*po) ; $(INTLTOOL_MERGE) $(top_srcdir)/po $< $@ -d -u -c $(top_builddir)/po/.intltool-merge-cache

resources.c: module.gresource.xml $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir=$(top_srcdir)/examples/tienda/modules/dashboard/ $(top_srcdir)/examples/tienda/modules/dashboard/module.gresource.xml)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/examples/tienda/modules/dashboard/ --generate-source $<

noinst_LTLIBRARIES = libdash.la

libdash_la_LIBADD = \
	$(LIBRUBRIC_GTK_LIBS) \
	$(top_builddir)/librubric/librubric.la \
	$(top_builddir)/librubric-gtk/librubric-gtk.la

libdash_la_SOURCES = \
	resources.c \
	views/dashboard-view.vala

libdash_la_CFLAGS = \
	$(LIBRUBRIC_GTK_CFLAGS) \
	-I$(top_builddir)/librubric \
	-I$(top_builddir)/librubric-gtk \
	`pkg-config --cflags --libs $(pkg_gtk_modules) gio-2.0` \
	-shared

libdash_la_VALAFLAGS = \
	--gresources $(top_srcdir)/examples/tienda/modules/dashboard/module.gresource.xml \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg libxml-2.0 \
	--pkg gtk+-3.0 \
	--pkg rubric-1.0 \
	--pkg libpeas-1.0 \
	--pkg rubric-gtk-1.0 \
	--vapidir=$(top_srcdir)/librubric \
	--vapidir=$(top_srcdir)/librubric-gtk \
	--target-glib=2.40.0 \
	--library dash \
	--vapi dash-1.0.vapi \
	--gir=Dashboard-1.0.gir \
	-g

dash-resources.c: dash-module.gresource.xml $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir=$(top_srcdir)/examples/tienda/modules/dashboard/ $(top_srcdir)/examples/tienda/modules/dashboard/dash-module.gresource.xml)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/examples/tienda/modules/dashboard/ --generate-source $<

dashboard_moduledir = $(datadir)/tienda/modules/dashboard
dist_dashboard_module_DATA = $(plugin_in_files:.plugin.in=.plugin)

plugindir = $(datadir)/tienda/modules/dashboard
plugin_LTLIBRARIES = libdashboard.la

libdashboard_la_LIBADD = \
	$(LIBRUBRIC_GTK_LIBS) \
	./libdash.la \
	$(top_builddir)/librubric/librubric.la \
	$(top_builddir)/librubric-gtk/librubric-gtk.la

libdashboard_la_SOURCES = \
	dash-resources.c \
	module.vala

libdashboard_la_CFLAGS = \
	$(LIBRUBRIC_GTK_CFLAGS) \
	-I. \
	-I$(top_builddir)/librubric \
	-I$(top_builddir)/librubric-gtk \
	`pkg-config --cflags --libs $(pkg_gtk_modules) gio-2.0` \
	-shared

libdashboard_la_VALAFLAGS = \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg libxml-2.0 \
	--pkg gtk+-3.0 \
	--pkg libpeas-1.0 \
	--pkg rubric-1.0 \
	--pkg rubric-gtk-1.0 \
	--pkg dash-1.0 \
	--vapidir=. \
	--vapidir=$(top_srcdir)/librubric \
	--vapidir=$(top_srcdir)/librubric-gtk \
	--target-glib=2.40.0 \
	-g

dashboard-glade-catalog.xml: Dashboard-1.0.gir
	$(GLADE_GEN) $<
	
CLEANFILES = \
	$(libdashboard_la_SOURCES:.vala=.c) \
	*.c \
	*.plugin \
	*.gir \
	*.vapi \
	$(GLADE_FILES)

EXTRA_DIST = \
	$(plugin_in_files)	

noinst_DATA = \
	$(GLADE_FILES) \
	module.gresource.xml
	
-include $(top_srcdir)/git.mk
