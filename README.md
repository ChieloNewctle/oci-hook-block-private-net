# oci-hook-block-private-net

[![License](https://img.shields.io/badge/license-MIT-informational.svg)](./LICENSE)
[![Build status](https://github.com/ChieloNewctle/oci-hook-block-private-net/actions/workflows/build-deb.yml/badge.svg)](https://github.com/ChieloNewctle/oci-hook-block-private-net/actions)

OCI hook that, when enabled, loads an nftables table in the container network
namespace. Outbound IPv4 to configured private/non-public prefixes is rejected.
Inbound TCP/UDP is allowed.

## Install

`deb` is available on `fury.io`. To add the repository to `apt`:

```bash
curl https://apt.fury.io/chielo/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/fury-chielo.gpg
sudo tee /etc/apt/sources.list.d/fury-chielo.sources > /dev/null <<EOF
Types: deb
URIs: https://apt.fury.io/chielo/
Suites: /
Signed-By: /etc/apt/keyrings/fury-chielo.gpg
EOF
sudo apt update
sudo apt install oci-hook-block-private-net
```

## Usage

```bash
podman run --annotation block-private-net=1 ...
```

Either `1` or `true` can be used.

## License

This project is licensed under the [MIT License](./LICENSE).
