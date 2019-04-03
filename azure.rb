require 'net/http'
require 'net/https'
require 'uri'
require 'json'

class Azure

  @@Azure_url = URI.parse "https://azuredcip.azurewebsites.net/getazuredcipranges"
  @azure_subnets
  @azure_zones

  def initialize args
    raise TypeError, "Array or String expected" if !(args.is_a?(Array) || args.is_a?(String))
    raise ArgumentError, "No zones given" if args.empty?
    @azure_zones = args if args.is_a? Array
    @azure_zones = [args] if args.is_a? String
    @azure_subnets = Array.new
    apiCall()
  end

  def getAzureSubnets
    return @azure_subnets.uniq.sort
  end

  def updateAzureSubnets
    @azure_subnets = Array.new
    apiCall
  end

  private

  def apiCall
    # Build the request+
    header = {"Content-Type" => "text/json"}
    body = {:request => "dcip", :region => "all"}
    req = Net::HTTP::Post.new @@Azure_url.request_uri, header
    req.body = body.to_json
    http = Net::HTTP.new @@Azure_url.host, @@Azure_url.port
    http.use_ssl = true
    # Make the request to Azure API for All subnets

      res = http.request req
      if res.code == "200" then
        azure_json = JSON.parse res.body
        loadZones azure_json
      else
        raise IOError, "Invaild response from Azure API: #{res.code} - #{res.body}"
      end
  end

  def loadZones json
    raise TypeError, "JSON Hash Expected" if !json.is_a? Hash
    @azure_zones.each do |zone|
      json[zone].each {|subnet| @azure_subnets.push subnet}
    end
  end

end
