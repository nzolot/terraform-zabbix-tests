locals {
  templates_web = {
    accounts = {
      steps = [
        {
          uri = "/v1/{SERVICE}/lifecycle/health"
        },
        {
          uri = "/v1/{SERVICE}"
          headers = {
            Content-Type = "application/json"
          }
          search_string = "\"data\":"
        }
      ]
    }
#
#    users = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#        {
#          uri = "/v1/{SERVICE}"
#          headers = {
#            Content-Type = "application/json"
#          }
#          search_string = "\"data\":"
#        }
#      ]
#    }
#
#    transfers = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#        {
#          uri = "/v1/{SERVICE}"
#          headers = {
#            Content-Type = "application/json"
#          }
#          search_string = "\"data\":"
#        }
#      ]
#    }
#
#    notes = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#      ]
#    }
#
#    limits = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#      ]
#    }
#
#    tenantsettings = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#        {
#          uri = "/v1/{SERVICE}"
#          headers = {
#            Content-Type = "application/json"
#          }
#          search_string = "\"tenant_id\":\"{$TENANT_ID}\""
#        }
#      ]
#    }
#
#
#    fees = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#        {
#          uri = "/v1/{SERVICE}"
#          headers = {
#            Content-Type = "application/json"
#          }
#          search_string = "\"data\":"
#        }
#      ]
#    }
#
#    charges = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#        {
#          uri = "/v1/{SERVICE}"
#          headers = {
#            Content-Type = "application/json"
#          }
#          search_string = "\"data\":"
#        }
#      ]
#    }
#
#    cardproducts = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#        {
#          uri = "/v1/{SERVICE}"
#          headers = {
#            Content-Type = "application/json"
#          }
#          search_string = "\"data\":"
#        }
#      ]
#    }
#
#    cards = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#        {
#          uri = "/v1/{SERVICE}"
#          headers = {
#            Content-Type = "application/json"
#          }
#          search_string = "\"data\":"
#        }
#      ]
#    }
#
#    notificationtemplates = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#      ]
#    }
#
#    notifications = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#      ]
#    }
#
#    "3ds" = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#      ]
#    }
#
#    admins = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#      ]
#    }
#
#    oauth2 = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#      ]
#    }
#
#    transactions = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#      ]
#    }
#
#    frauddetection = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#      ]
#    }
#
#    tokens = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#      ]
#    }
#
#    allowedcountries = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#        {
#          uri = "/v1/{SERVICE}"
#          headers = {
#            Content-Type = "application/json"
#          }
#          search_string = "\"data\":"
#        }
#      ]
#    }
#
#    orders = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#      ]
#    }
#
#    identityverification = {
#      steps = [
#        {
#          uri = "/v1/{SERVICE}/lifecycle/health"
#        },
#      ]
#    }

  }

  headers = {
    ApiKey = "{$TENANT_KEY}"
  }
}

resource "zabbix_template" "api" {
  provider  = zabbix.zabbix60

  for_each    = local.templates_web
  host        = "Template Nymcard Platform API ${each.key}"
  groups      = ["Templates"]
  description = "Template for monitoring API service '${each.key}'"
  macro = {
    API_BASE_URL = "undef"
    ENVIRONMENT  = "undef"
    TENANT_ID    = "undef"
    TENANT_KEY   = "undef"

    GRACE_TIME          = "15m"
    WEB_UPDATE_INTERVAL = "5m"

    FLAPPING_TIME  = "30m"
    FLAPPING_COUNT = "10"
  }
}

resource "zabbix_web_check" "api" {
  provider  = zabbix.zabbix60

  for_each = local.templates_web
  host_id  = zabbix_template.api[each.key].id
  name     = "Service ${each.key} check"

  delay   = "{$WEB_UPDATE_INTERVAL}"
  retries = 3

  dynamic "steps" {
    for_each = each.value.steps
    content {
      order         = tostring(steps.key + 1)
      name          = try(steps.value.name, "Get ${replace(steps.value.uri, "{SERVICE}", each.key)}")
      url           = "{$API_BASE_URL}${replace(steps.value.uri, "{SERVICE}", each.key)}"
      headers       = merge(try(steps.value.headers, {}), local.headers)
      status_codes  = try(steps.value.status_codes, "200")
      search_string = try(steps.value.search_string, null)
    }
  }
}
#
resource "zabbix_trigger" "api_web_check" {
  provider  = zabbix.zabbix60

  for_each    = local.templates_web
  description = "Web check for service ${each.key} failed on {HOST.NAME}"
  expression  = "min(/${zabbix_template.api[each.key].host}/web.test.fail[Service ${each.key} check],{$GRACE_TIME})>0"
  priority    = 4
  tags = {
    service = each.key
  }
  depends_on = [
    zabbix_web_check.api
  ]
}
#
#resource "zabbix_trigger" "api_web_flap" {
#  provider  = zabbix.zabbix60
#
#  for_each    = local.templates_web
#  description = "Web check for service ${each.key} is flapping {HOST.NAME}"
#  expression  = "changecount(/${zabbix_template.api[each.key].host}/web.test.fail[Service ${each.key} check],{$FLAPPING_TIME},\"all\")>{$FLAPPING_COUNT}"
#  priority    = 3
#  tags = {
#    type = "flapping"
#  }
#  dependencies = [
#    zabbix_trigger.api_web_check[each.key].id
#  ]
#  depends_on = [
#    zabbix_web_check.api
#  ]
#}

#resource "zabbix_service" "xx" {
#  provider  = zabbix.zabbix60
#  name      = "test123"
#
#  algorithm = "0"
#}
#
#resource "zabbix_service" "xx2" {
#  provider  = zabbix.zabbix60
#  name      = "test1233"
#
#  algorithm = "0"
#
#  parents = [
#    zabbix_service.xx.id
#  ]
#}
#
#
#output "zabbix_service_xx" {
#  value = zabbix_service.xx
#}

resource "zabbix_proxy" "test" {
  provider  = zabbix.zabbix60
  host      = "test"
  passive   = false
  address   = "1.1.1.3"
}
