module Planify
  class Limitations
    include ActiveSupport::Inflector

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

    private

    def normalize_class(klass)
      return klass.name if klass.is_a? Module
      return klass.name if klass.respond_to? :new # Class constant

      if klass.is_a?(String) || klass.is_a?(Symbol)
        computed_class = constantize camelize(klass.to_s)
        computed_class.to_s
      else
        klass.class.name
      end
    end

  end
end