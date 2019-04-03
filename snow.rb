require 'net/http'
require 'net/https'
require 'openssl'
require 'uri'
require 'json'

class Snow

  @snow_url
  @snow_user
  @snow_pass

  def initialize url, user, pass
    @snow_url = URI.parse url
    @snow_user = user
    @snow_pass = pass
  end

  def getRequest
    # Build the request+
    header = {"Accept" => "text/json"}
    Net::HTTP.start(@snow_url.host, @snow_url.port,
      {:use_ssl => @snow_url.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_PEER}) do |http|

        req = Net::HTTP::Get.new @snow_url.request_uri
        req.basic_auth @snow_user, @snow_pass

        res = http.request req

        puts res.body

      end


    end

  end

s = Snow.new "https://kpmgau.service-now.com/api/now/table/requests", "bstenhouse2"
s.getRequest()
