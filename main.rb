require_relative 'azure'
require_relative 'memory'
require_relative 'output'
require 'date'
# require_local 'snow'

# Zone interested in
Kpmg_Zones = ["australiasoutheast", "australiaeast"]
Changes = {"Added": [], "Removed": []}

Az = Azure.new Kpmg_Zones
Mem = Memory.new
# outputing to a daily file for testing
Out = Output.new "./Test/azure_changes_#{DateTime.now().to_date()}.txt", Output::CISCO
#Out = Output.new "./Test/azure_changes.txt"

# Compare
Changes["Removed"] = Mem.getMemory - Az.getAzureSubnets
Changes["Added"] = Az.getAzureSubnets - Mem.getMemory

Out.writeOutput Changes

Mem.writeMemory Az.getAzureSubnets

# create SNOW request
