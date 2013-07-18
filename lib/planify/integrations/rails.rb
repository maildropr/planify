module Planify
  module Integrations

    module Rails

      class Railtie < Rails::Railtie
        ActionController::Base.send(:include, ActionControllerExtensions)
      end

      module ActionControllerExtensions
        def not_authorized!
          raise "Limit exceeded"
        end

        def enforce_limit!(user, limitable)
          not_authorized! unless user.can_create?(limitable)
        end
      end

    end

  end
end