# Override the entire function with patched build instructions for reproducibility
do_compile() {
	mkdir -p ${S}/src/github.com/containernetworking
	ln -sfr ${S}/src/import ${S}/src/github.com/containernetworking/cni

	# our copied .go files are to be used for the build
	ln -sf vendor.copy vendor

	# inform go that we know what we are doing
	cp ${WORKDIR}/modules.txt vendor/

	export GO111MODULE=off

	cd ${B}/src/github.com/containernetworking/cni/libcni
	${GO} build ${GOBUILDFLAGS} -trimpath -ldflags '-s -w -buildid='

	cd ${B}/src/github.com/containernetworking/cni/cnitool
	${GO} build ${GOBUILDFLAGS} -trimpath -ldflags '-s -w -buildid='

	cd ${B}/src/github.com/containernetworking/plugins
	PLUGINS="$(ls -d plugins/meta/*; ls -d plugins/ipam/*; ls -d plugins/main/* | grep -v windows)"
	mkdir -p ${B}/plugins/bin/
	for p in $PLUGINS; do
	    plugin="$(basename "$p")"
	    echo "building: $p"
	    ${GO} build ${GOBUILDFLAGS} -trimpath -ldflags '-X github.com/containernetworking/plugins/pkg/utils/buildversion.BuildVersion=${CNI_VERSION} -s -w -buildid=' -o ${B}/plugins/bin/$plugin github.com/containernetworking/plugins/$p
	done
}
