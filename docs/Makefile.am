-include $(top_srcdir)/git.mk
-include $(top_srcdir)/librubric/librubric.am

VALADOC_FLAGS = \
	--force \
	--pkg gio-2.0 \
	--pkg glib-2.0 \
	--pkg gtk+-3.0 \
	--pkg gee-0.8 \
	--pkg libxml-2.0 \
	--pkg libpeas-1.0 \
	--vapidir $(top_srcdir)/vapi \
	--package-name Rubric \
	--package-version $(VERSION) \
	--target-glib=2.40.0 \
	$(top_srcdir)/librubric/rubric-1.0.vapi \
	$(top_srcdir)/librubric-gtk/rubric-gtk-1.0.vapi

# $(addprefix $(top_srcdir)/librubric/,$(librubric_sources))

valadoc:
	$(VALADOC) \
		-o valadoc \
		$(VALADOC_FLAGS)

devhelp:
	$(VALADOC) \
		-o devhelp \
		--doclet devhelp \
		$(VALADOC_FLAGS)

gtkdoc:
	$(VALADOC) \
		-X $(top_srcdir)/librubric/rubric.h \
		-X $(top_srcdir)/librubric-gtk/rubric-gtk.h \
		-X -l -X $(top_srcdir)/librubric/.libs/librubric.so \
		-X -l -X $(top_srcdir)/librubric-gtk/.libs/librubric-gtk.so \
		-o gtkdoc \
		--doclet gtkdoc \
		$(VALADOC_FLAGS)

clean-local:
	rm -rf valadoc devhelp gtkdoc

uninstall-hook:
	rm -rf $(DESTDIR)$(datadir)/devhelp/books/Rubric
	rm -rf $(DESTDIR)$(datadir)/gtk-doc/html/Rubric

install-data-hook: devhelp gtkdoc
	$(MKDIR_P) $(DESTDIR)$(datadir)/devhelp/books/Rubric/img
	$(INSTALL_DATA) -t $(DESTDIR)$(datadir)/devhelp/books/Rubric devhelp/Rubric/*.*
	$(INSTALL_DATA) -t $(DESTDIR)$(datadir)/devhelp/books/Rubric/img devhelp/Rubric/img/*
	$(MKDIR_P) $(DESTDIR)$(datadir)/gtk-doc/html/Rubric
	cp -R gtkdoc/html $(DESTDIR)$(datadir)/gtk-doc/html/Rubric

html: valadoc #devhelp gtkdoc

all: html
