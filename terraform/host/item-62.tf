data "zabbix_host" "zabbix62" {
  provider = zabbix.zabbix62
  host_id  = zabbix_host.zabbix62.host_id
}

output "data_zabbix_host_zabbix62" {
  value = data.zabbix_host.zabbix62
}

resource "zabbix_item" "zabbix62" {
  provider     = zabbix.zabbix62
  name         = "Test item"
  type         = 3
  value_type   = 3
  key          = "net.tcp.service[https,example.com]"
  delay        = "5m"
  description  = "Get status of example.com"
  history      = "1w"
  trends       = "90d"
  host_id      = data.zabbix_host.zabbix62.host_id
  interface_id = data.zabbix_host.zabbix62.main_interface_id

  preprocessing {
    type                 = 12
    params               = "first"
    error_handler        = "0"
    error_handler_params = ""
  }

  preprocessing {
    type                 = 12
    params               = "xx"
    error_handler        = "0"
    error_handler_params = ""
  }

  preprocessing {
    type                 = 21
    params               = "hello worldx"
    error_handler        = "0"
    error_handler_params = ""
  }


  tags = {
    test = "true"
    x    = false
  }
}

resource "zabbix_item" "zabbix62_dependent" {
  provider     = zabbix.zabbix62
  status       = 1
  name         = "Test dependent"
  type         = 18
  value_type   = 3
  key          = "dependent.test1"
  description  = "Dependent Test #1"
  history      = "1w"
  trends       = "90d"
  host_id      = data.zabbix_host.zabbix62.host_id

  master_itemid = zabbix_item.zabbix62.id

  preprocessing {
    type                 = 12
    params               = "first"
    error_handler        = "0"
    error_handler_params = ""
  }

  preprocessing {
    type                 = 12
    params               = "xx"
    error_handler        = "0"
    error_handler_params = ""
  }


  tags = {
    test = "true"
    x = false
  }
}