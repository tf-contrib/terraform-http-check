# terraform-http-check

[![CI](https://github.com/tf-contrib/terraform-http-check/actions/workflows/ci.yml/badge.svg)](https://github.com/tf-contrib/terraform-http-check/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/tf-contrib/terraform-http-check?include_prereleases)](https://github.com/tf-contrib/terraform-http-check/releases)
[![License](https://img.shields.io/badge/License-MPL--2.0-brightgreen.svg)](LICENSE)
[![OpenTofu](https://img.shields.io/badge/OpenTofu-compatible-FFDA18?logo=opentofu&logoColor=black)](https://opentofu.org)

An [OpenTofu](https://opentofu.org) and Terraform module that warns when a URL,
such as a service's health endpoint, doesn't answer `200`. It asks at the end of
every plan and apply, so a service that's deployed but broken shows up in the
run that deployed it, not in whatever calls it next.

```hcl
module "api_ready" {
  source = "git::https://github.com/tf-contrib/terraform-http-check.git?ref=v0.1.0" # x-release-please-version

  url  = "${module.api.url}/health/ready"
  hint = "503 if a secret can't be read, 500 if the config is wrong. The service's logs say why."
}
```

When the URL answers anything else, the run ends with a warning:

```
Warning: Check block assertion failed

https://api.example.com/health/ready answered 503: 503 if a secret can't be read, 500 if the config is wrong. The service's logs say why.
```

## How it behaves

- **It never fails a run.** It's a [`check`](https://opentofu.org/docs/language/checks/)
  block: a status other than `200`, or a request that fails outright, is a
  warning.
- **It gives up quickly.** Each request times out after `request_timeout_ms`,
  5s by default, and is tried again `retries` times, 3 by default, 1 to 5
  seconds apart: within about 25s in all. A firewall that silently drops the
  request costs seconds, not minutes.
- **It asks after everything else.** OpenTofu runs checks at the end of plan
  and apply, so on apply it asks the service as just deployed. On the very
  first plan, before the service exists, it warns once.
- **To turn it off, leave it out**, for example with
  `count = var.check_health ? 1 : 0`. Do that where runs can't reach the
  URL, such as runners whose egress is allowlisted: there it would only ever
  warn.

## Inputs

| Name | Required | Default | Description |
|---|---|---|---|
| `url` | yes | | The URL to check, `http://` or `https://`. |
| `hint` | no | `null` | What a status other than `200` means, appended to the warning. |
| `request_timeout_ms` | no | `5000` | How long each request may take, in milliseconds. |
| `retries` | no | `3` | How many times to try again after a request fails. |

## Outputs

| Name | Description |
|---|---|
| `url` | The URL the check asks. |

## Development

```sh
nix develop                     # OpenTofu
tofu fmt -recursive
tofu init -backend=false && tofu test
```

The tests plan the module with a mocked provider: no network needed.

## License

[MPL-2.0](LICENSE)
