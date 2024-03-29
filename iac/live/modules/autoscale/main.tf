/*
- Notification Block
- Profile Block-1: Default Profile
  1. Capacity Block
  2. Percentage CPU Metric Rules
    1. Scale-Up Rule: Increase VMs by 1 when CPU usage is greater than 75%
    2. Scale-In Rule: Decrease VMs by 1 when CPU usage is lower than 25%
*/

resource "azurerm_monitor_autoscale_setting" "web_vmss_autoscale" {
  name                = "${var.prefix}-web-vmss-autoscale-profiles"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = var.web_vmss_id
  tags                = var.tags

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["dickyrahmahermawan@gmail.com"]
    }
  }

  profile {
    name = "default"
    # Capacity Block
    capacity {
      default = 1
      minimum = 1
      maximum = 2
    }
    # Percentage CPU Metric Rules
    # Scale-Out
    rule {
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT1M"
      }

      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = var.web_vmss_id
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75 # Increase 1 VM when CPU usage is greater than 75%
      }
    }

    # Scale-In
    rule {
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT1M"
      }

      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = var.web_vmss_id
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25 # Decrease 1 VM when CPU usage is less than 25%
      }
    }
  }
}

resource "azurerm_monitor_autoscale_setting" "app_vmss_autoscale" {
  name                = "${var.prefix}-app-vmss-autoscale-profiles"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = var.app_vmss_id
  tags                = var.tags

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["dickyrahmahermawan@gmail.com"]
    }
  }

  profile {
    name = "default"
    # Capacity Block
    capacity {
      default = 1
      minimum = 1
      maximum = 2
    }
    # Percentage CPU Metric Rules
    # Scale-Out
    rule {
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT1M"
      }

      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = var.app_vmss_id
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75 # Increase 1 VM when CPU usage is greater than 75%
      }
    }

    # Scale-In
    rule {
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT1M"
      }

      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = var.app_vmss_id
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25 # Decrease 1 VM when CPU usage is less than 25%
      }
    }
  }
}
