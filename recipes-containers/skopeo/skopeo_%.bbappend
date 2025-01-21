# Override the entire function with patched EXTRA_LDFLAGS for reproducibility
do_compile() {
	export GOARCH="${TARGET_GOARCH}"

	export GOPATH="${S}/src/import/.gopath:${S}/src/import/vendor:${STAGING_DIR_TARGET}/${prefix}/local/go:${WORKDIR}/git/"
	cd ${S}

	# Pass the needed cflags/ldflags so that cgo
	# can find the needed headers files and libraries
	export CGO_ENABLED="1"
	export CFLAGS=""
	export LDFLAGS=""
	export CGO_CFLAGS="${TARGET_CFLAGS}"
	export CGO_LDFLAGS="${TARGET_LDFLAGS}"

	export GO111MODULE=off
	export GOBUILDFLAGS="-trimpath"
	export EXTRA_LDFLAGS="-s -w -buildid="

	oe_runmake bin/skopeo
}