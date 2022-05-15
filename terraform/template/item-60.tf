resource "zabbix_item" "zabbix60" {
  provider     = zabbix.zabbix60
  name         = "Test item"
  type         = 3
  value_type   = 3
  key          = "net.tcp.service[https,example.com]"
  delay        = "5m"
  description  = "Get status of example.com"
  history      = "1w"
  trends       = "90d"
  host_id      = zabbix_template.zabbix60.id

  tags = {
    test = "true"
    x = false
  }
}
