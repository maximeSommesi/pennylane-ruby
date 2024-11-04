# frozen_string_literal: true

require_relative "pennylane/version"
require 'pennylane/configuration'
require 'pennylane/object'
require 'pennylane/list_object'
require 'pennylane/util'
require 'pennylane/client'
require 'forwardable'
# require 'ostruct'
require 'uri'
require 'net/http'

Dir[File.join(__dir__, 'pennylane/resources/*.rb')].each {|file| require file }

require 'pennylane/object_types'

module Pennylane
  class Error < StandardError; end
  class AuthenticationError < Error; end
  class ConfigurationError < Error; end
  class NotFoundError < Error; end

  @config = Pennylane::Configuration.new
  # So we can have a module Pennylane that can be a class as well Pennylane.api_key = '1234'
  class << self
    extend Forwardable
    def_delegators :@config, :api_key, :api_key=
  end
end
