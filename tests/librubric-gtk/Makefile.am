CLEANFILES =
DISTCLEANFILES =

include $(top_srcdir)/build/autotools/glib-tap.mk

TESTS_ENVIRONMENT += \
	G_MESSAGES_DEBUG=all \
	G_SLICE=debug-blocks

test_programs = test-librubric-gtk-1.0

test_librubric_gtk_1_0_SOURCES =  \
	application/menu-extension.vala \
	application/menu-manager.vala \
	application/utils.vala

test_librubric_gtk_1_0_VALAFLAGS = \
	-g \
	--library test-librubric-gtk \
	--gir test-librubric-gtk-1.0.gir \
	--pkg gee-0.8 \
	--pkg valadate-1.0 \
	--pkg gtk+-3.0 \
	--pkg libxml-2.0 \
	--pkg rubric-1.0 \
	--pkg config \
	--vapidir=$(top_builddir)/librubric \
	--vapidir=$(top_builddir)/vapi

test_librubric_gtk_1_0_LDADD = \
	$(LIBRUBRIC_GTK_LIBS) \
	$(TESTS_LIBS) \
	$(top_builddir)/librubric/librubric.la

test_librubric_gtk_1_0_CPPFLAGS = \
	-fPIE

test_librubric_gtk_1_0_CFLAGS = \
	$(LIBRUBRIC_GTK_CFLAGS) \
	$(TESTS_CFLAGS) \
	-I$(top_builddir)/librubric \
	-shared \
	-pie \
	-g

test_librubric_gtk_1_0_LDFLAGS =  \
	-fPIE \
	-rdynamic


CLEANFILES += \
	$(test_librubric_gtk_1_0_SOURCES:.vala=.c) \
	*.vapi \
	*.gir \
	*.stamp

DISTCLEANFILES += $(CLEANFILES)

-include $(top_srcdir)/git.mk
