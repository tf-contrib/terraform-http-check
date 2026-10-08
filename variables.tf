variable "url" {
  type        = string
  description = "The URL to check, such as https://example.com/health/ready."

  validation {
    condition     = can(regex("^https?://[^/]", var.url))
    error_message = "url must be an http:// or https:// URL."
  }
}

variable "hint" {
  type        = string
  description = "What a status other than 200 means, appended to the warning."
  default     = null
}

variable "request_timeout_ms" {
  type        = number
  description = "How long each request may take, in milliseconds."
  default     = 5000

  validation {
    condition     = var.request_timeout_ms > 0
    error_message = "request_timeout_ms must be more than 0."
  }
}

variable "retries" {
  type        = number
  description = "How many times to try again after a request fails, waiting 1 to 5 seconds between tries."
  default     = 3

  validation {
    condition     = var.retries >= 0 && floor(var.retries) == var.retries
    error_message = "retries must be a whole number, 0 or more."
  }
}
