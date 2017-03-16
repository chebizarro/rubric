AC_INIT([rubric],
	[1.0.0],
	[https://github.com/valadate-project/rubric/issues],
	[rubric],
	[https://github.com/valadate-project/rubric])

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AC_PREREQ([2.65])

AC_CONFIG_AUX_DIR([build/aux])
AC_CONFIG_MACRO_DIR([build/autotools])
AC_CONFIG_HEADER([config.h])
AC_CONFIG_SRCDIR([Makefile.am])

AM_INIT_AUTOMAKE([1.11 foreign subdir-objects])

AM_MAINTAINER_MODE([enable])

dnl === Check for Compilers ============================================

AM_PROG_AR
AM_PATH_GLIB_2_0
AC_PROG_CC
AM_PROG_CC_C_O
AC_PATH_PROG(VALAC, valac, valac)
AC_SUBST(VALAC)

dnl === i18n ===========================================================

IT_PROG_INTLTOOL([0.40.0])

AM_GLIB_GNU_GETTEXT

dnl AM_GNU_GETTEXT([external])
dnl AM_GNU_GETTEXT_VERSION([0.19])

AS_IF([test "$USE_NLS" = "yes"],
		[AC_DEFINE([ENABLE_NLS], [1], [Defined if native language support should be enabled.])])

GETTEXT_PACKAGE=AC_PACKAGE_NAME
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE,"$GETTEXT_PACKAGE",[The name of the gettext domain])


dnl === OS Check =======================================================

AC_CANONICAL_HOST

case $host_os in
  *mingw*)
    platform_win32=yes
    native_win32=yes
    platform_darwin=no
    platform_linux=no
    ;;
  *darwin*)
    platform_win32=no
    native_win32=no
    platform_darwin=yes
    platform_linux=no
    ;;
  *linux*)
    platform_win32=no
    native_win32=no
    platform_darwin=no
    platform_linux=yes
    ;;
  pw32* | *cygwin*)
    platform_win32=yes
    native_win32=no
    platform_darwin=no
    platform_linux=no
    ;;
  *)
    AC_MSG_ERROR([OS $host_os is currently not supported])
    ;;
esac
AM_CONDITIONAL(PLATFORM_WIN32, test x"$platform_win32" = "xyes")
AM_CONDITIONAL(NATIVE_WIN32, test x"$native_win32" = "xyes")
AM_CONDITIONAL(PLATFORM_DARWIN, test x"$platform_darwin" = "xyes")
AM_CONDITIONAL(PLATFORM_LINUX, test x"$platform_linux" = "xyes")

LT_PREREQ([2.2.6])
LT_INIT([disable-static win32-dll])

# Honor aclocal flags
ACLOCAL="$ACLOCAL $ACLOCAL_FLAGS"

dnl === librubric ======================================================

GLIB_REQUIRED=2.40.0

LIBRUBRIC_LIB_DIR=[${PWD}/librubric]
AC_SUBST(LIBRUBRIC_LIB_DIR)

pkg_modules="glib-2.0 gobject-2.0 gee-0.8 libxml-2.0 gobject-introspection-1.0"

PKG_CHECK_MODULES([LIBRUBRIC], [$pkg_modules])

# for older pkg-config macros (<0.24)
AC_SUBST(pkg_modules)
AC_SUBST(LIBRUBRIC_CFLAGS)
AC_SUBST(LIBRUBRIC_LIBS)

dnl === librubric-gtk ==================================================

GTK_REQUIRED=3.10.0

LIBRUBRIC_GTK_LIB_DIR=[${PWD}/librubric-gtk]
AC_SUBST(LIBRUBRIC_GTK_LIB_DIR)

pkg_gtk_modules="$pkg_modules gtk+-3.0 libpeas-1.0 libpeas-gtk-1.0"

PKG_CHECK_MODULES([LIBRUBRIC_GTK], [$pkg_gtk_modules])

# for older pkg-config macros (<0.24)
AC_SUBST(pkg_gtk_modules)
AC_SUBST(LIBRUBRIC_GTK_CFLAGS)
AC_SUBST(LIBRUBRIC_GTK_LIBS)

dnl === Tests ==========================================================

pkg_tests_modules="valadate-1.0"

PKG_CHECK_MODULES([TESTS], [$pkg_tests_modules])

# for older pkg-config macros (<0.24)
AC_SUBST(pkg_tests_modules)
AC_SUBST(TESTS_CFLAGS)
AC_SUBST(TESTS_LIBS)

dnl === Check for Introspection/Test ===================================

GLIB_TESTS

GOBJECT_INTROSPECTION_CHECK([1.38.0])

dnl === Documentation with Valadoc =====================================

AC_ARG_ENABLE([docs],
	AS_HELP_STRING([--enable-docs],[Enable documentation generation]),
	[enable_docs=$enableval], [enable_docs=no])

AM_CONDITIONAL([ENABLE_DOCS], [test x$enable_docs = xyes])

have_valadoc=no
if test x$enable_docs = xyes; then
	# make sure the library is new enough and the program exists
	AC_PATH_PROG([VALADOC], [valadoc], [no])
	AC_SUBST(VALAC_VERSION,[m4_esyscmd([vala --version | awk -F. '{ print "0."$2 }'])])
	if test "x$VAPIDIR" = "x"; then
		VAPIDIR=`$PKG_CONFIG --variable=vapidir libvala-$VALAC_VERSION`
	fi
	AC_SUBST([VAPIDIR])
	if test "x$VALADOC" = "xno"; then
		AC_MSG_RESULT([valadoc documentation not built because not found])
	else
		have_valadoc="yes"
		AC_SUBST(VALADOC)
		PKG_CHECK_MODULES([GTKDOC], gtk-doc)
		have_gtkdoc=yes
	fi
fi
AM_CONDITIONAL([HAVE_VALADOC], [test x$have_valadoc = xyes])

dnl === Check for Development Mode =====================================

AC_ARG_ENABLE(devmode,
	AS_HELP_STRING([--enable-devmode],[enable development mode]),
	enable_development="$enableval",
	enable_development=no)
if test "x$enable_development" = "xyes"; then
	development_mode="yes"
	LIBRUBRIC_LIB_DIR=[${PWD}/librubric]
	TESTS_DIR=[${PWD}/tests]
	dnl Remove all optimization flags from CFLAGS
	LIBRUBRIC_CFLAGS="-Og $LIBRUBRIC_CFLAGS"
	LIBRUBRIC_GTK_CFLAGS="-Og $LIBRUBRIC_GTK_CFLAGS"
	TESTS_CFLAGS="-Og $TESTS_CFLAGS"
else
	development_mode="no"
	LIBRUBRIC_LIB_DIR='$(libdir)'
	LIBRUBRIC_DATA_DIR='$(datadir)/librubric'
fi

AC_SUBST(LIBRUBRIC_LIB_DIR)
AC_SUBST(TESTS_DIR)
AC_SUBST(DEVELOPMENT_MODE)
AM_CONDITIONAL([ENABLE_DEVELOPMENT_MODE], [test x$development_mode = xyes])

AH_TEMPLATE([DEVELOPMENT_MODE], [Whether in development mode or not])
AC_DEFINE_UNQUOTED([DEVELOPMENT_MODE], ["$DEVELOPMENT_MODE"],[Development mode])


dnl === Test coverage ==================================================

AC_ARG_ENABLE([gcov],
	[AS_HELP_STRING([--enable-gcov], [Enable gcov])],
	[use_gcov=$enableval],
	[use_gcov=no])

AS_IF([test "x$use_gcov" = "xyes"],
      [
        dnl we need gcc:
        AS_IF([test "$GCC" != "yes"], [AC_MSG_ERROR([GCC is required for --enable-gcov])])

        dnl Check if ccache is being used
        AC_CHECK_PROG(SHTOOL, shtool, shtool)
        AS_CASE([`$SHTOOL path $CC`],
                [*ccache*], [gcc_ccache=yes],
                [gcc_ccache=no])

        if test "$gcc_ccache" = "yes" && (test -z "$CCACHE_DISABLE" || test "$CCACHE_DISABLE" != "1"); then
          AC_MSG_ERROR([ccache must be disabled when --enable-gcov option is used. You can disable ccache by setting environment variable CCACHE_DISABLE=1.])
        fi

        ltp_version_list="1.6 1.7 1.8 1.9 1.10 1.11"
        AC_CHECK_PROG(LTP, lcov, lcov)
        AC_CHECK_PROG(LTP_GENHTML, genhtml, genhtml)

        if test "$LTP"; then
          AC_CACHE_CHECK([for ltp version], rubric_cv_ltp_version,
                         [
                           rubric_cv_ltp_version=invalid
                           ltp_version=`$LTP -v 2>/dev/null | $SED -e 's/^.* //'`
                           for ltp_check_version in $ltp_version_list; do
                             if test "$ltp_version" = "$ltp_check_version"; then
                               rubric_cv_ltp_version="$ltp_check_version (ok)"
                             fi
                           done
                         ])
        else
          ltp_msg="To enable code coverage reporting you must have one of the following LTP versions installed: $ltp_version_list"
          AC_MSG_ERROR([$ltp_msg])
        fi

        case $rubric_cv_ltp_version in
          ""|invalid[)]
          ltp_msg="You must have one of the following versions of LTP: $ltp_version_list (found: $ltp_version)."
          AC_MSG_ERROR([$ltp_msg])
          LTP="exit 0;"
          ;;
        esac

        if test -z "$LTP_GENHTML"; then
          AC_MSG_ERROR([Could not find genhtml from the LTP package])
        fi

        AC_DEFINE(HAVE_GCOV, 1, [Whether you have gcov])

        dnl Remove all optimization flags from CFLAGS
        changequote({,})
        CFLAGS=`echo "$CFLAGS" | $SED -e 's/-O[0-9]*//g'`
        LIBRUBRIC_CFLAGS=`echo "$LIBRUBRIC_CFLAGS" | $SED -e 's/-O[0-9]*//g'`
        TESTS_CFLAGS=`echo "$TESTS_CFLAGS" | $SED -e 's/-O[0-9]*//g'`
        changequote([,])

        dnl Define the special gcc flags
        LIBRUBRIC_GCOV_CFLAGS="-O0 -fprofile-arcs -ftest-coverage"
        LIBRUBRIC_GCOV_LDADD="-lgcov"
        TESTS_GCOV_CFLAGS="-O0 -fprofile-arcs -ftest-coverage"
        TESTS_GCOV_LDADD="-lgcov"

        AC_SUBST(LIBRUBRIC_GCOV_CFLAGS)
        AC_SUBST(LIBRUBRIC_GCOV_LDADD)
        AC_SUBST(TESTS_GCOV_CFLAGS)
        AC_SUBST(TESTS_GCOV_LDADD)

        LIBRUBRIC_CFLAGS="$LIBRUBRIC_CFLAGS $LIBRUBRIC_GCOV_CFLAGS"
        LIBRUBRIC_LIBS="$LIBRUBRIC_LIBS $LIBRUBRIC_GCOV_LDADD"
        TESTS_CFLAGS="$TESTS_CFLAGS $TESTS_GCOV_CFLAGS"
        TESTS_LIBS="$TESTS_LIBS $TESTS_GCOV_LDADD"
      ])

AM_CONDITIONAL(ENABLE_GCOV, test "x$use_gcov" = "xyes")

dnl === Output Makefiles ===============================================

AC_CONFIG_FILES([
	Makefile
	build/Makefile
	build/autotools/Makefile
	build/aux/Makefile
	docs/Makefile
	librubric/Makefile
	librubric/rubric-1.0.pc
	librubric-gtk/Makefile
	librubric-gtk/rubric-gtk-1.0.pc
	librubric-orm/Makefile
	librubric-orm/rubric-orm-1.0.pc
	tools/Makefile
	tests/Makefile
	tests/librubric/Makefile
	tests/librubric-orm/Makefile
	po/Makefile.in
	examples/Makefile
	examples/tienda/Makefile
	examples/tienda/data/Makefile
	examples/tienda/modules/Makefile
	examples/tienda/modules/users/Makefile
	examples/tienda/modules/dashboard/Makefile
	examples/tienda/modules/stock/Makefile
	examples/tienda/modules/sales/Makefile
])

AC_OUTPUT

dnl === Summary ========================================================

echo ""
echo " Rubric - $VERSION"
echo ""
echo " • Prefix: ${prefix}"
echo ""
echo " • Compiler flags: ${LIBRUBRIC_CFLAGS} ${LIBRUBRIC_GTK_CFLAGS}"
echo ""
echo " • Enable code coverage: ${use_gcov}"
echo ""
echo " • Building on: ${host_os}"
echo ""
echo " • Development mode: ${enable_development}"
echo ""
echo " • Documentation: ${enable_docs}"
echo ""
