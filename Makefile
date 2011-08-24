#!/usr/bin/make -f

package = $(shell grep ^Name: *.spec | awk '{print $$2}')
version = $(shell grep ^Version: *.spec | awk '{print $$2}')

ifneq ($(wildcard /etc/redhat-release),)
 distro = redhat
endif

ifneq ($(wildcard /etc/debian_version),)
 distro = debian
endif

ifeq (${distro},)
 $(error unknown distribution, specify distro={debian,redhat})
endif

all:

install:
	install -D -m755 libexec/virtualmaster-firstboot \
		${DESTDIR}/usr/libexec/virtualmaster-firstboot
	install -D -m755 init.d/virtualmaster.${distro} \
		${DESTDIR}/etc/init.d/virtualmaster
	install -D -m644 tpl/hosts.tpl \
		${DESTDIR}/usr/share/virtualmaster/hosts.tpl
	install -D -m644 tpl/ifcfg.tpl \
		${DESTDIR}/usr/share/virtualmaster/ifcfg.tpl
	install -D -m644 tpl/interfaces.tpl \
		${DESTDIR}/usr/share/virtualmaster/interfaces.tpl
	install -D -m644 tpl/network.tpl \
		${DESTDIR}/usr/share/virtualmaster/network.tpl
	install -D -m644 tpl/resolv.tpl \
		${DESTDIR}/usr/share/virtualmaster/resolv.tpl
	install -D -m644 rc.sysinit.patch \
		${DESTDIR}/usr/share/virtualmaster/rc.sysinit.patch
	install -D -m644 doc/virtualmaster.cfg.sample \
		${DESTDIR}/usr/share/doc/${package}/virtualmaster.cfg.sample
ifeq (${distro}, debian)
	mkdir -p ${DESTDIR}/etc/rcS.d
	ln -sf ../init.d/virtualmaster ${DESTDIR}/etc/rcS.d/S00virtualmaster
endif

clean:

dist:
	tar -cvpzf "../${package}-${version}.tar.gz" \
		--transform="s#.*#${package}-${version}/\0#" \
		--show-stored-names *

# EOF
