provider "zabbix" {
  alias      = "zabbix50"
  server_url = "http://127.0.0.1:8085/api_jsonrpc.php"
  user       = "Admin"
  password   = "zabbix"
}

resource "zabbix_host_group" "zabbix50" {
  provider = zabbix.zabbix50
  name     = "Test Group"
}

resource "zabbix_host" "zabbix50" {
  provider  = zabbix.zabbix50
  name      = "test-host"
  host      = "test-host"
  monitored = true
  groups    = [zabbix_host_group.zabbix50.name]
  macro     = {}
  templates = []

  interfaces {
    ip   = "127.0.0.1"
    dns  = "test.local"
    main = true
  }
}
