resource "zabbix_trigger" "zabbix50" {
  provider     = zabbix.zabbix50
  status       = 0
  description  = "test-trigger"
  expression   = "{${zabbix_template.zabbix50.host}:${zabbix_item.zabbix50.key}.last()}<1"
  priority     = 3
  dependencies = []
  tags = {
    key   = "value"
    macro = "{$TEST}"
  }
}

resource "zabbix_trigger" "zabbix50_dep" {
  provider     = zabbix.zabbix50
  status       = 0
  description  = "test-trigger-dep"
  expression   = "{${zabbix_template.zabbix50.host}:${zabbix_item.zabbix50.key}.last()}<1"
  priority     = 3
  dependencies = [
    zabbix_trigger.zabbix50.id
  ]
  tags = {
    key   = "value"
    macro = "{$TEST}"
  }
}

output "zabbix_trigger_zabbix50" {
  value = zabbix_trigger.zabbix50
}