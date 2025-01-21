INSANE_SKIP:${PN} += "already-stripped"

do_compile:prepend() {
  export EXTRA_LDFLAGS="-s -w -buildid="
}
