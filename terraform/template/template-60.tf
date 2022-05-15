provider "zabbix" {
  alias      = "zabbix60"
  server_url = "http://127.0.0.1:8086/api_jsonrpc.php"
  user       = "Admin"
  password   = "zabbix"
}

resource "zabbix_template" "zabbix60" {
  provider    = zabbix.zabbix60
  host        = "demo template"
  groups      = ["Discovered hosts"]
  description = "A basic template"
  macro = {
    EXAMPLE = "85"
  }
}
