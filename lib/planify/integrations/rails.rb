module Planify
  module Integrations

    module Rails

      def self.included(base)
        base.class_eval do
          extend Helpers
          include Helpers
          helper Helpers
        end
      end
      
      module Helpers
        def limit_exceeded!
          raise "Limit exceeded"
        end

        def enforce_limit!(user, limitable)
          limit_exceeded! unless user.can_create? limitable
        end
      end
    end

  end
end