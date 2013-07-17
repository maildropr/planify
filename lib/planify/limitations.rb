require "planify/util/class_normalizer"

module Planify
  class Limitations
    include ActiveSupport::Inflector
    include Planify::ClassNormalizer

    def initialize
      @limits = Hash.new
    end

    def set(klass, limit)
      key = normalize_class(klass)
      @limits[key] = limit
    end

    def get(klass, default_limit = -1)
      key = normalize_class(klass)

      begin
        @limits.fetch(key)
      rescue
        return default_limit
      end
    end

  end
end