require "planify/integrations/rails"

module Planify
  class Railtie < Rails::Railtie
    initializer 'planify.hooks' do |app|
      ActionController::Base.class_eval do
        include Planify::Integrations::Rails
      end
    end
  end
end