terraform {
  required_providers {
    zabbix = {
      source  = "local/nzolot/zabbix"
      version = "1.0.15"
    }
  }
  required_version = ">= 1.1"
}
