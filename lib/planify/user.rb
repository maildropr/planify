require "planify/util/class_normalizer"

module Planify
  module User
    include Planify::ClassNormalizer

    def has_plan(plan_name, &block)
      @plan = Planify::Plans.get(plan_name)

      if block_given?
        @plan = @plan.dup
        @plan.instance_eval &block
      end
    end

    def plan
      @plan
    end

  end
end