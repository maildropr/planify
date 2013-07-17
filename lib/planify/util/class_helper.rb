module Planify
  module ClassHelper

    def normalize_class(klass)
      return klass.name if klass.is_a? Module
      return klass.name if klass.respond_to? :new # Class constant

      if klass.is_a?(String) || klass.is_a?(Symbol)
        computed_class = constantize camelize(klass.to_s)
        computed_class.to_s
      else
        klass.class.name
      end
    end # normalize_class

  end
end