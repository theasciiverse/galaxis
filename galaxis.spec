Name: galaxis
Version: 1.8
Release: 1
URL: http://www.catb.org/~esr/galaxis/
Source0: %{name}-%{version}.tar.gz
License: BSD
Group: Games
Summary: Galaxis (screen mode)
BuildRoot: %{_tmppath}/%{name}-root
#Destinations: freshmeat

%description
A UNIX-hosted, curses-based clone of the nifty little Macintosh
freeware game Galaxis.

%prep
%setup -q

%build
make %{?_smp_mflags} galaxis galaxis.6

%install
[ "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != / ] && rm -rf "$RPM_BUILD_ROOT"
mkdir -p "$RPM_BUILD_ROOT"%{_bindir}
mkdir -p "$RPM_BUILD_ROOT"%{_mandir}/man6/
cp galaxis "$RPM_BUILD_ROOT"%{_bindir}
cp galaxis.6 "$RPM_BUILD_ROOT"%{_mandir}/man6/

%clean
[ "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != / ] && rm -rf "$RPM_BUILD_ROOT"

%files
%doc README COPYING
%defattr(-,root,root,-)
%{_mandir}/man6/galaxis.6*
%{_bindir}/galaxis

%changelog
* Tue Oct 18 2010 Eric S. Raymond <esr@snark.thyrsus.com> - 1.8-1
- Full ANSIfication.  License changed to BSD.

* Mon Dec 29 2003 Eric S. Raymond <esr@snark.thyrsus.com> 1.7
- Mac OSX port fix. 

* Fri Dec 26 2003 Eric S. Raymond <esr@snark.thyrsus.com> 1.6
- Cleanup fixes to RPM packaging machinery.

* Mon Dec 15 2003 Eric S. Raymond <esr@snark.thyrsus.com> 1.5
- Minor bug fix from James Hiller.

* Tue Jul 30 2002 Eric S. Raymond <esr@thyrsus.com> 1.4
- Moved documentation to XML.

* Sat Apr 20 2002 Eric S. Raymond <esr@thyrsus.com> 1.3
- Applied James Hiller's fix for multiple-reprobe bug.

* Fri Jul 28 2000 Eric S. Raymond <esr@thyrsus.com> 1.2
- Update to modern RPM tools.

RPM seems to choke on changelog entry dates older than 1997...

Sun Oct 23 1994 Eric S. Raymond <esr@thyrsus.com> 1.1
- Original release.
