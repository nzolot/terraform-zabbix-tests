provider "zabbix" {
  alias      = "zabbix50"
  server_url = "http://127.0.0.1:8085/api_jsonrpc.php"
  user       = "Admin"
  password   = "zabbix"
}

resource "zabbix_template" "zabbix50" {
  provider    = zabbix.zabbix50
  host        = "demo template"
  groups      = ["Discovered hosts"]
  description = "A basic template"
  macro = {
    EXAMPLE = "85"
  }
}
