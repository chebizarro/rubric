GLADE_GEN = ../../../../tools/glade-catalogger

GLADE_FILES = users-glade-catalog.xml

plugin_in_files = users.plugin.in
%.plugin: %.plugin.in $(INTLTOOL_MERGE) $(wildcard $(top_srcdir)/po/*po) ; $(INTLTOOL_MERGE) $(top_srcdir)/po $< $@ -d -u -c $(top_srcdir)/po/.intltool-merge-cache

resources.c: module.gresource.xml $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir=$(top_srcdir)/examples/tienda/modules/users/ $(top_srcdir)/examples/tienda/modules/users/module.gresource.xml)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/examples/tienda/modules/users/ --generate-source $<

users_moduledir = $(datadir)/tienda/modules/users
dist_users_module_DATA = $(plugin_in_files:.plugin.in=.plugin)

plugindir = $(datadir)/tienda/modules/users
plugin_LTLIBRARIES = libusers.la

libusers_la_LIBADD = \
	$(LIBRUBRIC_GTK_LIBS) \
	$(top_builddir)/librubric/librubric.la \
	$(top_builddir)/librubric-gtk/librubric-gtk.la

libusers_la_SOURCES = \
	resources.c \
	module.vala \
	views/login-view.vala \
	view-models/login-view-model.vala

libusers_la_CFLAGS = \
	$(LIBRUBRIC_GTK_CFLAGS) \
	-I$(top_srcdir)/librubric \
	-I$(top_srcdir)/librubric-gtk \
	`pkg-config --cflags --libs $(pkg_gtk_modules) gio-2.0` \
	-shared

libusers_la_VALAFLAGS = \
	--gresources module.gresource.xml \
	--pkg gio-2.0 \
	--pkg gee-0.8 \
	--pkg libxml-2.0 \
	--pkg gtk+-3.0 \
	--pkg libpeas-1.0 \
	--pkg rubric-1.0 \
	--pkg rubric-gtk-1.0 \
	--vapidir=$(top_builddir)/librubric \
	--vapidir=$(top_builddir)/librubric-gtk \
	--target-glib=2.40.0 \
	--library users \
	--vapi users-1.0.vapi \
	--gir=Users-1.0.gir \
	-g

users-glade-catalog.xml: $(top_srcdir)/examples/tienda/modules/users/Users-1.0.gir
	$(GLADE_GEN) $<
	
CLEANFILES = \
	$(libusers_la_SOURCES:.vala=.c) \
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
