data "zabbix_host" "zabbix50" {
  provider = zabbix.zabbix50
  host_id  = zabbix_host.zabbix50.host_id
}

output "data_zabbix_host_zabbix50" {
  value = data.zabbix_host.zabbix50
}

resource "zabbix_item" "zabbix50" {
  provider     = zabbix.zabbix50
  name         = "Test item"
  type         = 3
  value_type   = 3
  key          = "net.tcp.service[https,example.com]"
  delay        = "5m"
  description  = "Get status of example.com"
  history      = "1w"
  trends       = "90d"
  host_id      = data.zabbix_host.zabbix50.host_id
  interface_id = data.zabbix_host.zabbix50.main_interface_id
}
