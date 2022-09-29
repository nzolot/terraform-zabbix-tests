provider "zabbix" {
  alias      = "zabbix62"
  server_url = "http://127.0.0.1:8087/api_jsonrpc.php"
  user       = "Admin"
  password   = "zabbix"
}

resource "zabbix_host_group" "zabbix62" {
  provider = zabbix.zabbix62
  name     = "Test Group"
}

resource "zabbix_host" "zabbix62" {
  provider  = zabbix.zabbix62
  name      = "test-host"
  host      = "test-host"
  monitored = true
  groups    = [zabbix_host_group.zabbix62.name]
  macro     = {
    KEY = "value"
  }
  tags = {
    test = "yes"
  }
  templates = []

  interfaces {
    ip   = "127.0.0.1"
    dns  = "test.local"
    main = true
  }
}

output "zabbix_host_zabbix62" {
  value = zabbix_host.zabbix62
}
