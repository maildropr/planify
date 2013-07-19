require "planify/integrations/rails"

module Planify
  class PlanifyRailtie < Rails::Railtie
    initializer "planify.hooks" do
      ActionController::Base.send(:include, Planify::Integrations::Rails)
    end
  end
end