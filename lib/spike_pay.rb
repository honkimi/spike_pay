require 'faraday'
begin
  require 'mutli_json'
  JSON_CLASS = MultiJson
rescue LoadError
  require 'json'
  JSON_CLASS = JSON
end

class SpikePay
  attr_reader :conn
  attr_accessor :charge
  attr_accessor :token

  # Initialize client
  #
  # @param options [Hash] options
  def initialize(auth_token, options = {})
    options = options.each_with_object({}) { |kv, obj| k,v = kv; obj[k.to_s] = v }

    connection_options = options['faraday_options'] || {}
    connection_options['headers'] = {
      "Content-Type" => "application/x-www-form-urlencoded",
      "Accept" => "application/json",
      "User-Agent" => "Apipa-spike/1.0.0",
      "Accept-Language" => "ja",
    }
    connection_options['url'] = options['api_base'] || 'https://api.spike.cc/v1'
    @conn = Faraday.new(connection_options) do |builder|
      builder.request :url_encoded
      builder.adapter Faraday.default_adapter
    end


    @conn.basic_auth(auth_token, '')
    @charge = SpikePay::Charge.new(self)
  end

  def set_accept_language(value)
    @conn.headers['Accept-Language'] = value
  end


  # Convert faraday response to a hash by decoding JSON.
  # This raises error if the response indicates error status.
  #
  # @api private
  # @param response [Faraday::Response]
  # @return [Hash] Raw object
  # @raise [SpikePay::SpikeError] For invalid requests (4xx) or internal server error (5xx)
  def handle_response(response)
    data =
      begin
        JSON_CLASS.load(response.body.force_encoding(infer_encoding(response)))
      rescue JSON_CLASS::ParserError => e
        raise SpikePay::ApiConnectionError.invalid_json(e)
      end
    status = response.status
    case status
    when 200..299
      data
    else
      if  status == 400
        raise SpikePay::ErrorResponse::InvalidRequestError.new(status, data)
      end
      if  status == 401
        raise SpikePay::ErrorResponse::AuthenticationError.new(status, data)
      end
      if  status == 402
        raise SpikePay::ErrorResponse::CardError.new(status, data)
      end
      if  status == 404
        raise SpikePay::ErrorResponse::InvalidRequestError.new(status, data)
      end
      if  true
        raise SpikePay::ErrorResponse::ApiError.new(status, data)
      end
      raise "Unknown error is returned"
    end
  end

  def request(method, url_pattern ,params)
    url = url_pattern.gsub(/:([[:alnum:]]+)/) { |name| params.__send__(name[1..-1]) }
    begin
      response = @conn.__send__(method, url, [:get, :delete].include?(method) ? params.to_h : params.to_h.collect do |k,v| 
        if k != "products"
          "#{k}=#{v}"
        else
          "#{k}=[#{JSON.dump(v[0])}]"
        end
      end.join('&'))
    rescue Faraday::Error::ClientError, URI::InvalidURIError => e
      raise SpikePay::ApiConnectionError.in_request(e)
    end
    handle_response(response)
  end

  private

  # Infer encoding from response
  #
  # @param response [Faraday::Response]
  # @return [Encoding]
  def infer_encoding(response)
    unless (type = response.headers['content-type']) &&
        (charset = type.split(';').find { |field| field.include?('charset=') })
      return Encoding.default_external
    end

    encoding_string = charset.split('=', 2).last.strip
    Encoding.find(encoding_string)
  rescue
    Encoding.default_external
  end
end

require 'spike_pay/api_resource'
require 'spike_pay/error'
require 'spike_pay/charge'
require 'spike_pay/data_types'
require "spike_pay/version"
