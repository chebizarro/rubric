CLEANFILES =
DISTCLEANFILES =

include $(top_srcdir)/build/autotools/glib-tap.mk

TESTS_ENVIRONMENT += \
	G_MESSAGES_DEBUG=all \
	G_SLICE=debug-blocks

test_programs = test-mujs-1.0

test_mujs_1_0_SOURCES =  \
	mujs.vala \
	es-5.vala
	
test_mujs_1_0_VALAFLAGS = \
	-g \
	--library test-mujs \
	--gir test-mujs-1.0.gir \
	--pkg valadate-1.0 \
	--pkg rubric-web-1.0 \
	--pkg mujs-1.0 \
	--vapidir $(builddir)/../ \
	--vapidir $(top_builddir)/librubric \
	--vapidir $(top_builddir)/librubric-web

test_mujs_1_0_LDADD = \
	$(LIBRUBRIC_WEB_LIBS) \
	$(TESTS_LIBS) \
	$(top_builddir)/librubric/librubric.la \
	$(top_builddir)/librubric-web/librubric-web.la \
	$(builddir)/../libmujs-engine.la

test_mujs_1_0_CPPFLAGS = \
	-fPIE

test_mujs_1_0_CFLAGS = \
	$(LIBRUBRIC_WEB_CFLAGS) \
	$(TESTS_CFLAGS) \
	-I$(srcdir)/../ \
	-I$(top_srcdir)/librubric/ \
	-I$(top_srcdir)/librubric-web/ \
	-shared \
	-pie \
	-g

test_mujs_1_0_LDFLAGS =  \
	-fPIE \
	-rdynamic \
	-shared \
	-export-dynamic


-include $(top_srcdir)/git.mk
