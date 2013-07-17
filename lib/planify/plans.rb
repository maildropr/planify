module Planify
  module Plans

    @plans = ActiveSupport::HashWithIndifferentAccess.new

    def self.define(name, &block)
      plan = Plan.new
      plan.instance_eval(&block) if block_given?

      @plans[name] = plan
    end

    def self.get(name)
      begin
        @plans.fetch(name)
      rescue
        raise ArgumentError, "A plan named '#{name}' is not defined"
      end
    end

    def self.all
      @plans
    end

    def self.clear
      @plans.clear
    end

  end
end
