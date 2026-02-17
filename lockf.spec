Name:           lockf
Version:        1.0
Release:        1%{?dist}
Summary:        Execute a command while holding a file lock

License:        BSD-4-Clause
URL:            https://cgit.freebsd.org/src/tree/usr.bin/lockf
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  libnbcompat-devel

Requires:       libnbcompat


%global debug_package %{nil}

%description
lockf runs a command while holding an advisory file lock. It is
useful to serialize access to shared resources by executing a
command only while holding a file lock.

%prep
%setup -q

%build
make %{?_smp_mflags}

%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot}

%files
%doc README
%{_bindir}/lockf
%{_mandir}/man1/lockf.1*

%changelog
* Tue Jan 06 2026 Jonny <jonny@example.org> - 1.0-1
- Initial package.
