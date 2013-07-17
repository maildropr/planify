require "planify/util/class_normalizer"

module Planify

  # +Planify::Limitations+ is a simple container for Class constants and their associated limits
  class Limitations
    include ActiveSupport::Inflector
    include Planify::ClassNormalizer

    def initialize
      @limits = Hash.new
    end

    # Sets the limit for the given class constant
    # @param [String,Symbol,Class,Object] klass The class to set the limit for
    # @param [Integer] limit The number of instances of +klass+ which can be created
    # @return [Integer] The value of +limit+
    def set(klass, limit)
      key = normalize_class(klass)
      @limits[key] = limit
    end

    # Fetches the limit for the given class constant
    # @param [String,Symbol,Class,Object] klass The class to find the limit for
    # @param [Integer] default_limit The default value to return, if one is not defined for +klass+
    # @return [Integer] The limit value for +klass+, or +default_limit+ if none exists.
    def get(klass, default_limit = Float::INFINITY)
      key = normalize_class(klass)

      begin
        @limits.fetch(key)
      rescue
        return default_limit
      end
    end

    # Returns all limits defined in this instance
    # @return [Hash(String,Integer)] A hash mapping class constant name to it's limit
    def all
      @limits
    end

  end
end