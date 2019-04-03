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
    raise TypeError, "Hash expected" if !args.is_a? Hash
    raise ArgumentError, "No arguments giving" if args.empty?
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
    @file << "object-group network g-azure-datacentre\n"
    content["Removed"].each {|remove| @file << "no network-object #{toSubnet remove}\n"}
    content["Added"].each {|add| @file << "network-object #{toSubnet add}\n"}
    @file << "end\nwr\n"
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
