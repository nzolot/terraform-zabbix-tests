resource "zabbix_lld_rule" "zabbix62" {
  provider     = zabbix.zabbix62
  name         = "Test LLD"
  type         = 3
  key          = "lld.test.terraform"
  delay        = "5m"
  host_id      = data.zabbix_host.zabbix62.host_id
  interface_id = data.zabbix_host.zabbix62.main_interface_id

  filter {
    condition {
      macro = "{#FSTYPE}"
      value = "@fs"
    }
    condition {
      macro = "{#FSTYPEX}"
      value = "@fs"
    }
    eval_type = 1
  }

  lld_macros {
    macro = "{#TEST}"
    path  = "$.xx"
  }

  preprocessing {
    type                 = 12
    params               = "firsty"
    error_handler        = "0"
    error_handler_params = ""
  }

}

resource "zabbix_item_prototype" "zabbix62" {
  provider     = zabbix.zabbix62
  name         = "Test proto item"
  type         = 3
  key          = "prototype.test.terraform"
  delay        = "5m"
  host_id      = data.zabbix_host.zabbix62.host_id
  interface_id = data.zabbix_host.zabbix62.main_interface_id

  rule_id = zabbix_lld_rule.zabbix62.id

  preprocessing {
    type                 = 12
    params               = "firsty"
    error_handler        = "0"
    error_handler_params = ""
  }

  tags = {
    test = "true"
    x = false
  }
}