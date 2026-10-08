# terraform-http-check

[![CI](https://github.com/tf-contrib/terraform-http-check/actions/workflows/ci.yml/badge.svg)](https://github.com/tf-contrib/terraform-http-check/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/tf-contrib/terraform-http-check?include_prereleases)](https://github.com/tf-contrib/terraform-http-check/releases)
[![License](https://img.shields.io/badge/License-MPL--2.0-brightgreen.svg)](LICENSE)
[![OpenTofu](https://img.shields.io/badge/OpenTofu-compatible-FFDA18?logo=opentofu&logoColor=black)](https://opentofu.org)

An [OpenTofu](https://opentofu.org) and Terraform module that warns when a URL,
such as a service's health endpoint, doesn't answer `200`.

## Development

```sh
nix develop                     # OpenTofu
tofu fmt -recursive
tofu init -backend=false && tofu test
```

## License

[MPL-2.0](LICENSE)
