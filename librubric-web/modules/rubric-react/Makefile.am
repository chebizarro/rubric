plugin_in_files = rubric-react.plugin.in
%.plugin: %.plugin.in $(INTLTOOL_MERGE) $(wildcard $(top_srcdir)/po/*po) ; $(INTLTOOL_MERGE) $(top_srcdir)/po $< $@ -d -u -c $(top_builddir)/po/.intltool-merge-cache

noinst_LTLIBRARIES = librubric-react.la

librubric_react_la_LDFLAGS = \
	-shared -fPIC

librubric_react_la_LIBADD = \
	$(LIBRUBRIC_WEB_LIBS) \
	-lrubric-react \
	-lm \
	$(top_builddir)/librubric/librubric.la \
	$(top_builddir)/librubric-web/librubric-web.la

librubric_react_la_SOURCES = \
	src/core/babel.vala \
	src/core/component.vala \
	src/core/javascript-with-sourcemap.vala \
	src/core/react-environment.vala \
	src/core/source-map.vala

librubric_react_la_CFLAGS = \
	$(LIBRUBRIC_WEB_CFLAGS) \
	-I$(top_srcdir)/librubric \
	-I$(top_srcdir)/librubric-web \
	`pkg-config --cflags --libs $(pkg_web_modules) gio-2.0` \
	-shared

librubric_react_la_VALAFLAGS = \
	--pkg rubric-web-1.0 \
	--vapidir=$(top_builddir)/librubric \
	--vapidir=$(top_builddir)/librubric-web \
	--vapidir=$(builddir)/vapi \
	--target-glib=2.40.0 \
	--shared-library=librubric-react.so \
	--library=rubric-react \
	--vapi=rubric-react-1.0.vapi \
	--gir=RubricReact-1.0.gir \
	--header=rubric-react.h


EXTRA_DIST = \
	$(plugin_in_files)	

-include $(top_srcdir)/git.mk
