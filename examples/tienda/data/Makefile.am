gresource_file = tienda.gresource.xml

schema_file = org.tienda.app.gschema.xml

gsettings_SCHEMAS =	\
	$(schema_file)

@GSETTINGS_RULES@

gschemas.compiled: $(schema_file)
	$(GLIB_COMPILE_SCHEMAS) $(top_srcdir)/examples/tienda/data

if ENABLE_DEVELOPMENT_MODE
all: gschemas.compiled

CLEANFILES = gschemas.compiled

endif

resource_files = \
	shell.ui \
	logo.svg
	
noinst_DATA = \
	$(resource_files)

EXTRA_DIST = \
	$(gresource_file) \
	$(resource_files)


-include $(top_srcdir)/git.mk
