FILESEXTRAPATHS:prepend := "${THISDIR}/:"

SRC_URI += "file://podman-init \
            file://containers.conf"

inherit update-rc.d

INITSCRIPT_NAME = "podman-init"
INITSCRIPT_PARAMS = "defaults 99"

do_install:append() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/podman-init ${D}${sysconfdir}/init.d/podman-init

    install -d ${D}${sysconfdir}/containers
    install -m 0644 ${WORKDIR}/containers.conf ${D}${sysconfdir}/containers/containers.conf
}

DEPENDS += "pasta"
RDEPENDS:${PN} += "pasta"

FILES:${PN} += "${sysconfdir}/init.d/podman-init \
                ${sysconfdir}/containers/containers.conf"