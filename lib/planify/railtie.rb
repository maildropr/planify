require "planify/integrations/rails"

module Planify
  class Railtie < Rails::Railtie
    initializer 'planify.hooks' do |app|
      ActiveSupport.on_load(:action_controller) do
        extend Planify::Integrations::Rails::Helpers
        include Planify::Integrations::Rails::Helpers
      end
    end
  end
end