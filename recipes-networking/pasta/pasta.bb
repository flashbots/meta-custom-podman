SUMMARY = "Plug A Simple Socket Transport"
HOMEPAGE = "https://passt.top/"
LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/:"

SRC_URI = "git://passt.top/passt;branch=master;protocol=https \
           file://no-pivot-root.patch"

PV = "0+git${SRCPV}"
SRCREV = "2024_06_24.1ee2eca"

S = "${WORKDIR}/git"

DEPENDS += "coreutils-native"

do_compile() {
    oe_runmake
}

do_install() {
    oe_runmake DESTDIR=${D} install
}
