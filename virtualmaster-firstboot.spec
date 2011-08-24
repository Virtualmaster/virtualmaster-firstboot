Name:       virtualmaster-firstboot
Version:    0.2
Release:    1
Summary:    Configures network and users on first boot of VM
License:    GPL
URL:        http://www.virtualmaster.cz
Group:      System/Boot
Source:     virtualmaster-firstboot-%{version}.tar.gz
Requires:   patch
BuildRoot:  %{_tmppath}/buildroot-%{name}-%{version}
BuildArch:  noarch

%description
Configures network and users on first boot of VM
Virtualmaster package is a set of scripts to kickoff freshly installed
virtual machine. Most of tasks are performed only once, on first boot.
Idea of this package is to have one universal distro-independent config
file and then set of distro-specific packages (e.g. .deb, .rpm, .tgz).
Main tasks are:
    - set up networking (IP, gateway, nameservers) on first booot
    - resize root filesystem to actual size of partition
    - ensure swap partition has swap signature
    - set root's password
    - optionaly create users and add ssh keys

%prep
%setup -q

%build

%install
make DESTDIR=%{buildroot} install

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root)
%{_sysconfdir}/init.d/*
%{_libexecdir}/*
%{_datadir}/virtualmaster/*
%doc %{_docdir}/virtualmaster/*

%preun
cd /etc/rc.d
patch -Rr- -i /usr/share/virtualmaster/rc.sysinit.patch
%post
cd /etc/rc.d
patch -r- -i /usr/share/virtualmaster/rc.sysinit.patch

%changelog
* Wed Aug 24 2011 Jan Dvořák <jd@vmin.cz> <0.2> <1>
- unified Debian and RedHat
- implemented IPv6 settings

* Fri Jun 26 2009 Josef Liska <jl@chl.cz> <0.1> <1>
- initial release

