CLEANFILES =
DISTCLEANFILES =

include $(top_srcdir)/build/autotools/glib-tap.mk

TESTS_ENVIRONMENT += \
	G_MESSAGES_DEBUG=all \
	G_SLICE=debug-blocks

test_programs = test-v8-1.0

test_v8_1_0_SOURCES =  \
	v8.vala
	
test_v8_1_0_VALAFLAGS = \
	-g \
	--library test-v8 \
	--gir test-v8-1.0.gir \
	--pkg valadate-1.0 \
	--pkg rubric-web-v8-1.0 \
	--pkg rubric-web-1.0 \
	--vapidir=/home/developer/build/rubric/librubric-web/modules/v8-engine \
	--vapidir=$(top_builddir)/librubric \
	--vapidir=$(top_builddir)/librubric-web

test_v8_1_0_LDADD = \
	-lm \
	$(LIBRUBRIC_WEB_LIBS) \
	$(TESTS_LIBS) \
	$(top_builddir)/librubric/librubric.la \
	$(top_builddir)/librubric-web/librubric-web.la \
	$(builddir)/../libv8-engine.la

test_v8_1_0_CPPFLAGS = \
	-fPIE

test_v8_1_0_CFLAGS = \
	$(LIBRUBRIC_WEB_CFLAGS) \
	$(TESTS_CFLAGS) \
	-I$(srcdir)/../ \
	-I$(top_srcdir)/librubric/ \
	-I$(top_srcdir)/librubric-web/ \
	-shared \
	-pie \
	-g

test_v8_1_0_LDFLAGS =  \
	-fPIE \
	-rdynamic \
	-shared \
	-export-dynamic


-include $(top_srcdir)/git.mk
