provider "zabbix" {
  alias      = "zabbix60"
  server_url = "http://127.0.0.1:8086/api_jsonrpc.php"
  user       = "Admin"
  password   = "zabbix"
}

resource "zabbix_host_group" "zabbix60" {
  provider = zabbix.zabbix60
  name     = "Test Group2"
}

resource "zabbix_host" "zabbix60" {
  provider  = zabbix.zabbix60
  name      = "test-host2"
  host      = "test-host2"
  monitored = true
  groups    = [zabbix_host_group.zabbix60.name]
  macro     = {
    KEY = "value"
  }
  tags = {
    test = "yes"
  }
  templates = []

  proxy_hostid = zabbix_proxy.test.id

  interfaces {
    ip   = "127.0.0.1"
    dns  = "test.local"
    main = true
  }
}

#output "zabbix_host_zabbix60" {
#  value = zabbix_host.zabbix60
#}
