module Planify
  module Plans

    @plans = ActiveSupport::HashWithIndifferentAccess.new

    # Defines a new plan, evaluating the given block on the new plan instance.
    # @param [String, Symbol] name The name of the plan
    # @return [Planify::Plan] the new plan
    def self.define(name, &block)
      plan = Plan.new
      plan.instance_eval(&block) if block_given?

      @plans[name] = plan
    end

    # Gets a plan by name
    # @param [String,Symbol] name The name of the plan
    # @return [Planify::Plan] the plan represented by +name+
    # @raise [ArgumentError] if a plan named +name+ is not defined
    def self.get(name)
      begin
        @plans.fetch(name)
      rescue
        raise ArgumentError, "A plan named '#{name}' is not defined"
      end
    end

    # Returns the list of plans
    # @return [Array] an array of Planify::Plan instances
    def self.all
      @plans
    end

    # Removes all currently defined plans
    def self.clear
      @plans.clear
    end

  end
end
