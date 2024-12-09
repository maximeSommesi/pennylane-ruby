module Pennylane
  class Client
    BASE_URI = 'app.pennylane.com/api/external'.freeze
    VERSION = 'v1'.freeze

    attr_accessor :version, :key

    def initialize(key = nil, version: 'v1')
      @key = key || Pennylane::Configuration.current.api_key
      @version = version || Pennylane::Configuration.current.api_version
    end

    def url(path, query={})
      URI("https://#{BASE_URI}/#{VERSION}#{path}").tap do |uri|
        uri.query = URI.encode_www_form(query) if query
      end
    end

    def base_uri
      URI("https://#{BASE_URI}")
    end


    def authorization(key)
      "Bearer #{key}"
    end
    def http
      Net::HTTP.new(base_uri.host, base_uri.port).tap do |http|
        http.use_ssl = true
      end
    end

    def klass(method)
      Net::HTTP.const_get(method.to_s.capitalize)
    end

    def request(method, path, params: {}, opts: {})
      validate_configuration!
      req = initialize_request(method, path, params[:query], opts).tap do |req|
        req.body = params[:body].to_json if params[:body]
      end

      http.request(req).tap do |resp|
        handle_error_response(resp) if should_handle_as_error?(resp.code)
      end
    end

    private

    def validate_configuration!
      return if @key
      config = Pennylane::Configuration.current
      config.validate!
      @key ||= config.api_key
    end

    def handle_error_response(resp)
      case resp.code.to_i
      when 401
        raise Pennylane::AuthenticationError, resp.body
      when 404
        raise Pennylane::NotFoundError
      else
        error = JSON.parse(resp.read_body)
        raise Pennylane::Error, "#{resp.code} - #{error['message'] || error['error']}"
      end
    end

    def should_handle_as_error?(code)
      code.to_i >= 400
    end

    def initialize_request method=nil, path=nil, params={}, opts={}
      klass(method).new(url(path, params)).tap do |request|
        request["content-type"] = 'application/json'
        request["authorization"] = authorization(opts.fetch(:api_key, @key))
      end
    end

  end
end