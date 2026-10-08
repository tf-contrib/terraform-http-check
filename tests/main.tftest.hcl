# Plans the module with a mocked provider: no network needed. Covers the
# warning, which the check gives unless the URL answers 200, and the inputs.
mock_provider "http" {
  mock_data "http" {
    defaults = { status_code = 200 }
  }
}

variables {
  url = "https://example.com/health/ready"
}

run "passes_on_200" {
  command = plan

  assert {
    condition     = output.url == "https://example.com/health/ready"
    error_message = "the check should ask url"
  }
}

run "warns_on_another_status" {
  command = plan

  override_data {
    target = data.http.this
    values = { status_code = 503 }
  }

  expect_failures = [check.http]
}

run "takes_a_hint" {
  command = plan

  variables {
    hint = "503 if a secret can't be read"
  }

  override_data {
    target = data.http.this
    values = { status_code = 503 }
  }

  expect_failures = [check.http]
}

run "takes_no_retries" {
  command = plan

  variables {
    retries = 0
  }
}

run "rejects_a_url_without_a_scheme" {
  command = plan

  variables {
    url = "example.com/health/ready"
  }

  expect_failures = [var.url]
}

run "rejects_no_timeout" {
  command = plan

  variables {
    request_timeout_ms = 0
  }

  expect_failures = [var.request_timeout_ms]
}

run "rejects_fractional_retries" {
  command = plan

  variables {
    retries = 1.5
  }

  expect_failures = [var.retries]
}
