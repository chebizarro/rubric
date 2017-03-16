bin_PROGRAMS = glade-catalogger

glade_catalogger_SOURCES = \
	gc/main.vala
	
glade_catalogger_VALAFLAGS = \
	--pkg gio-2.0 \
	--pkg libxml-2.0 \
	--target-glib=2.40.0

if ENABLE_DEVELOPMENT_MODE

glade_catalogger_VALAFLAGS += \
	-D ENABLE_DEVELOPMENT_MODE \
	-g

endif

glade_catalogger_LDFLAGS = \
	`pkg-config --libs libxml-2.0 gio-2.0`
	
glade_catalogger_CFLAGS = \
	`pkg-config --cflags libxml-2.0 gio-2.0`

rubrik-gtk-glade-catalog.xml: ../librubric-gtk/RubricGtk-1.0.gir
	./glade-catalogger $<

CLEANFILES = \
	$(glade_catalogger_SOURCES:.vala=.c) \
	rubrik-gtk-glade-catalog.xml \
	gc/.dirstamp

noinst_DATA = \
	rubrik-gtk-glade-catalog.xml

include $(top_srcdir)/git.mk
