module Planify
  module Plan

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def limits
        @@limits ||= Limitations.new
      end

      def features
        @@features ||= Hash.new
      end

      def max(klazz, limit)
        limits.set(klazz, limit)
      end

      def limit(klazz)
        limits.get(klazz)
      end

      def feature(feature_name, enabled = true) 
        features[feature_name.to_sym] = enabled
      end

      def feature_enabled?(feature)
        features[feature.to_sym] || false
      end

      def feature_disabled?(feature)
        !feature_enabled?(feature)
      end
    end

  end
end