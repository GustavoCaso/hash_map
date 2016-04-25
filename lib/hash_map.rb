require 'hash_map/version'
require 'active_support/all'
module HashMap
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def root
      File.expand_path '../..', __FILE__
    end

    class Configuration
      attr_accessor :middlewares
      def initialize
        @middlewares = {}
      end
    end
  end
end
require 'hash_map/dsl'
require 'hash_map/mapper'
require 'hash_map/base'
require 'hash_map/json_adapter'

require 'hash_map/core_ext/hash'
require 'hash_map/core_ext/string'

