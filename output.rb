class Output

  @output_file
  @output_type
  @file

  TEXT = 0
  CISCO = 1
  PALO = 2

  def initialize file = "change.txt", type = TEXT
    @output_file = file
    @output_type = type
  end

  def writeOutput args
    @file = File.open @output_file, "w"
    if args["Added"].empty? && args["Removed"].empty? then
      @file << "No Changes"
    else
      textOutput args if @output_type == TEXT
      ciscoOutput args if @output_type == CISCO
      paloOutput args if @output_type == PALO
    end
    @file.close
  end

  private

  def textOutput content
    content["Added"].each {|add| @file << "Added #{add}\n"}
    content["Removed"].each {|remove| @file << "Removed #{remove}\n"}
  end

  def ciscoOutput content
    @file << "conf t\n"
    # Create a object for each new subnet
    content["Added"].each do |add|
      @file << "object network #{add.sub '/', "_"}\n"
      @file << "\tsubnet #{toSubnet add}\n"
      @file << "\texit\n"
    end
    # Create/Edit the g-azure-datacentre object
    @file << "object-group network g-azure-datacentre\n"
    # Remove subnet objects that have been removed
    content["Removed"].each {|remove| @file << "\tno network-object #{toSubnet remove}\n"}
    # Add subnet objects that have been added
    content["Added"].each {|add| @file << "\tnetwork-object object #{add.sub '/', "_"}\n"}
    # Exit config mode and write to flash
    @file << "\texit\nexit\nwr\n"
  end

  def paloOutput content

  end

  def toSubnet cidr
    ip, bits = cidr.split('/')
    return "#{ip} #{getNetmask bits}"
  end

  def getNetmask cidr
    IPAddr.new('255.255.255.255').mask(cidr).to_s
  end

end
