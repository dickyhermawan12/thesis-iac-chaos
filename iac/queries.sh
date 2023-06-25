#!/bin/bash

RG=iac-thesis-rg
VNET=iac-thesis-vnet

# azure query to list all vnet in a resource group
az network vnet list \
  -g $RG \
  --query '[].{Name:name}' \
  -o table

# azure query to list all subnets in a vnet (ipv4 address space, available ip, and delegations)
az network vnet subnet list \
  -g $RG \
  --vnet-name $VNET \
  --query '[].{Name:name, AddressPrefix:addressPrefix, AvailableIP:addressPrefixes[0], Delegations:delegations[0].serviceName}' \
  -o table
