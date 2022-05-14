provider "zabbix" {
  alias      = "zabbix60"
  server_url = "http://127.0.0.1:8086/api_jsonrpc.php"
  user       = "Admin"
  password   = "zabbix"
}

resource "zabbix_host_group" "zabbix60" {
  provider = zabbix.zabbix60
  name     = "Test Group"
}

resource "zabbix_host" "zabbix60" {
  provider  = zabbix.zabbix60
  name      = "test-host"
  host      = "test-host"
  monitored = true
  groups    = [zabbix_host_group.zabbix60.name]
  macro     = {}
  templates = []

  interfaces {
    ip   = "127.0.0.1"
    dns  = "test.local"
    main = true
  }
}
