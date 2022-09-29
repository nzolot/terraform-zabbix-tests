resource "zabbix_item" "zabbix60" {
  provider     = zabbix.zabbix60

  for_each     = local.templates_web
  name         = "Test item - ${each.key}"
  type         = 3
  value_type   = 3
  key          = "net.tcp.service[https,example.com]"
  delay        = "5m"
  description  = "Get status of example.com"
  history      = "1w"
  trends       = "90d"
  host_id      = zabbix_template.api[each.key].id

  tags = {
    test = "true"
    x = false
  }
}

resource "zabbix_trigger" "api_web_check2" {
  provider  = zabbix.zabbix60

  for_each    = local.templates_web
  description = "Web check for service ${each.key} failed on {HOST.NAME}"
  expression  = "min(/${zabbix_template.api[each.key].host}/${zabbix_item.zabbix60[each.key].key},{$GRACE_TIME})>0"
  priority    = 4
  tags = {
    service = each.key
  }
  depends_on = [
    zabbix_web_check.api
  ]
}