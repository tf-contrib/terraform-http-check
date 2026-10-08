# At the end of every plan and apply, a warning, never an error, unless the URL
# answers 200: a check block's data source turns a request that fails into a
# warning too. Retried a little, as a new custom domain takes a moment to
# resolve, and each request gives up after request_timeout_ms, so a firewall
# that drops it costs seconds, not minutes.
check "http" {
  data "http" "this" {
    url                = var.url
    request_timeout_ms = var.request_timeout_ms

    retry {
      attempts     = var.retries
      min_delay_ms = 1000
      max_delay_ms = 5000
    }
  }

  assert {
    condition     = data.http.this.status_code == 200
    error_message = "${var.url} answered ${data.http.this.status_code}${var.hint == null ? "" : ": ${var.hint}"}"
  }
}
