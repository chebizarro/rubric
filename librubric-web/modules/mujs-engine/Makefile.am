SUBDIRS = . tests

plugin_in_files = mujs-engine.plugin.in
%.plugin: %.plugin.in $(INTLTOOL_MERGE) $(wildcard $(top_srcdir)/po/*po) ; $(INTLTOOL_MERGE) $(top_srcdir)/po $< $@ -d -u -c $(top_builddir)/po/.intltool-merge-cache

noinst_LTLIBRARIES = libmujs-engine.la

libmujs_engine_la_LDFLAGS = \
	-shared -fPIC

libmujs_engine_la_LIBADD = \
	$(LIBRUBRIC_WEB_LIBS) \
	-lmujs \
	-lm \
	$(top_builddir)/librubric/librubric.la \
	$(top_builddir)/librubric-web/librubric-web.la

libmujs_engine_la_SOURCES = \
	mujs-engine.vala

libmujs_engine_la_CFLAGS = \
	$(LIBRUBRIC_WEB_CFLAGS) \
	-I$(top_srcdir)/librubric \
	-I$(top_srcdir)/librubric-web \
	`pkg-config --cflags --libs $(pkg_web_modules) gio-2.0` \
	-shared

libmujs_engine_la_VALAFLAGS = \
	--pkg rubric-web-1.0 \
	--pkg mujs \
	--vapidir=$(top_builddir)/librubric \
	--vapidir=$(top_builddir)/librubric-web \
	--vapidir=$(builddir)/vapi \
	--target-glib=2.40.0 \
	--shared-library=libmujs-engine.so \
	--library=mujs \
	--vapi=mujs-1.0.vapi \
	--gir=Mujs-1.0.gir \
	--header=libmujs.h


EXTRA_DIST = \
	$(plugin_in_files)	

noinst_DATA = \
	$(GLADE_FILES)

-include $(top_srcdir)/git.mk
