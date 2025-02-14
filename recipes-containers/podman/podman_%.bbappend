FILESEXTRAPATHS:prepend := "${THISDIR}/:"

SRC_URI += "file://podman-init \
            file://containers.conf"

inherit update-rc.d

INITSCRIPT_NAME = "podman-init"
INITSCRIPT_PARAMS = "defaults 60"

INSANE_SKIP:${PN} += "already-stripped"

do_compile() {
    cd ${S}/src
    rm -rf .gopath
    mkdir -p .gopath/src/"$(dirname "${PODMAN_PKG}")"
    ln -sf ../../../../import/ .gopath/src/"${PODMAN_PKG}"

    ln -sf "../../../import/vendor/github.com/varlink/" ".gopath/src/github.com/varlink"

    export GOARCH="${BUILD_GOARCH}"
    export GOPATH="${S}/src/.gopath"
    export GOROOT="${STAGING_DIR_NATIVE}/${nonarch_libdir}/${HOST_SYS}/go"
    export EXTRA_LDFLAGS="-s -w -buildid="

    cd ${S}/src/.gopath/src/"${PODMAN_PKG}"

    # Pass the needed cflags/ldflags so that cgo
    # can find the needed headers files and libraries
    export GOARCH=${TARGET_GOARCH}
    export CGO_ENABLED="1"
    export CGO_CFLAGS="${CFLAGS} --sysroot=${STAGING_DIR_TARGET}"
    export CGO_LDFLAGS="${LDFLAGS} --sysroot=${STAGING_DIR_TARGET}"

    # podman now builds go-md2man and requires the host/build details
    export NATIVE_GOOS=${BUILD_GOOS}
    export NATIVE_GOARCH=${BUILD_GOARCH}

    export BUILDFLAGS="-trimpath -buildvcs=false -ldflags '-s -w -buildid='"
    oe_runmake NATIVE_GOOS=${BUILD_GOOS} NATIVE_GOARCH=${BUILD_GOARCH} BUILDTAGS="${BUILDTAGS}" rootlessport
    unset BUILDFLAGS

    export GOFLAGS="-trimpath -buildvcs=false"
    oe_runmake NATIVE_GOOS=${BUILD_GOOS} NATIVE_GOARCH=${BUILD_GOARCH} BUILDTAGS="${BUILDTAGS}"
}

do_install:append() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/podman-init ${D}${sysconfdir}/init.d/podman-init

    install -d ${D}${sysconfdir}/containers
    install -m 0644 ${WORKDIR}/containers.conf ${D}${sysconfdir}/containers/containers.conf
}

DEPENDS += "pasta shadow"
RDEPENDS:${PN} += "pasta shadow"

FILES:${PN} += "${sysconfdir}/init.d/podman-init \
                ${sysconfdir}/containers/containers.conf"
