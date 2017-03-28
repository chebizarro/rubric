bin_PROGRAMS = travel-booker

travel_booker_SOURCES = \
	src/main.vala

travel_booker_VALAFLAGS = \
	--pkg rubric-web-1.0 \
	--vapidir=$(top_builddir)/librubric \
	--vapidir=$(top_builddir)/librubric-web \
	--target-glib=2.40.0
	
travel_booker_LDADD = \
	$(LIBRUBRIC_WEB_LIBS) \
	$(top_builddir)/librubric/librubric.la \
	$(top_builddir)/librubric-web/librubric-web.la

travel_booker_CFLAGS = \
	$(LIBRUBRIC_WEB_CFLAGS) \
	-I$(top_srcdir)/librubric \
	-I$(top_srcdir)/librubric-web \
	`pkg-config --cflags --libs $(pkg_web_modules)`


include $(top_srcdir)/git.mk
