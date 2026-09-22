#!/bin/bash
set -euo pipefail

PKG=oci-hook-block-private-net
VER=1.0.2
ARCH=all

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/src"

bin_src="$SRC/block-private-net"
json_src="$SRC/block-private-net.json"
[[ -f "$bin_src" && -f "$json_src" ]] || {
  echo "missing $bin_src or $json_src" >&2
  exit 1
}

STAGE="/tmp/${PKG}_${VER}_${ARCH}"
rm -rf "$STAGE"

bin_dst="$STAGE/usr/libexec/oci/hooks.d"
json_dst="$STAGE/usr/share/containers/oci/hooks.d"
ctrl_dst="$STAGE/DEBIAN"

install -d -m 0755 "$STAGE" "$bin_dst" "$json_dst" "$ctrl_dst"
install -m 0755 "$bin_src" "$bin_dst/block-private-net"
install -m 0644 "$json_src" "$json_dst/block-private-net.json"

cat >"$ctrl_dst/control" <<EOF
Package: $PKG
Version: $VER
Section: admin
Priority: optional
Architecture: $ARCH
Depends: bash, jq, util-linux, nftables
Maintainer: Chielo <mail@chielo.org>
Description: OCI hook to block container access to private IPv4
 Installs an OCI runtime hook that, when the annotation
 block-private-net is 1 or true, loads an nftables table
 in the container network namespace. Outbound IPv4 to configured
 private/non-public prefixes is rejected; inbound TCP/UDP is allowed.
EOF

(
  cd "$STAGE"
  find usr -type f -print0 | sort -z | xargs -0 md5sum
) >"$ctrl_dst/md5sums"

DEB=${PKG}_${VER}_${ARCH}.deb
dpkg-deb --root-owner-group --build "$STAGE" "$DEB"
echo "built $DEB"
