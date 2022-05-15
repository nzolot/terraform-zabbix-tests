resource "zabbix_trigger" "zabbix60" {
  provider     = zabbix.zabbix60
  status       = 0
  description  = "test-trigger"
  expression   = "last(/${zabbix_template.zabbix60.host}/${zabbix_item.zabbix60.key})<1"
  priority     = 3
  dependencies = []
  tags = {
    key   = "value"
    macro = "{$TEST}"
  }
}

resource "zabbix_trigger" "zabbix60_dep" {
  provider     = zabbix.zabbix60
  status       = 0
  description  = "test-trigger-dep"
  expression   = "last(/${zabbix_template.zabbix60.host}/${zabbix_item.zabbix60.key})<1"
  priority     = 3
  dependencies = [
    zabbix_trigger.zabbix60.id
  ]
  tags = {
    key   = "value"
    macro = "{$TEST}"
  }
}

output "zabbix_trigger_zabbix60" {
  value = zabbix_trigger.zabbix60
}