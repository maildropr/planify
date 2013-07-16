module Planify
  module Plan

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def limits
        @@limits ||= Limitations.new
      end

      def max(klazz, limit)
        limits.set(klazz, limit)
      end

      def limit(klazz)
        limits.get(klazz)
      end
    end

  end
end