require "planify/user/limitable_counts"
require "planify/user/plan_info"

require "planify/util/class_helper"

module Planify
  module User
    include Planify::ClassHelper

    def self.included(base)
      base.class_eval do
        embeds_one :planify_plan_info, as: :planify_user, class_name: "Planify::User::PlanInfo"
        embeds_one :planify_limitable_counts, as: :planify_user, class_name: "Planify::User::LimitableCounts"
      end
    end

    def has_plan(plan_name, &block)
      @plan = Planify::Plans.get(plan_name)
      self.planify_plan_info = PlanInfo.new(name: plan_name)

      if block_given?
        @plan = @plan.dup
        @configuration = Planify::Plan.new
        @configuration.instance_eval &block

        @plan.merge! @configuration

        self.planify_plan_info.limit_overrides = @configuration.limits.all
        self.planify_plan_info.feature_overrides = @configuration.features
      end
    end

    def plan
      @plan ||= load_plan_from_info(self.planify_plan_info)
    end

    def limitable_counts
      self.planify_limitable_counts ||= LimitableCounts.new
    end

    def creation_count(limitable)
      key = normalize_class(limitable)
      limitable_counts.fetch(key)
    end

    def created(limitable)
      key = normalize_class(limitable)
      limitable_counts.increment(key)
    end

    def destroyed(limitable)
      key = normalize_class(limitable)
      limitable_counts.decrement(key)
    end

    def can_create?(limitable)
      key = normalize_class(limitable)
      limitable_counts.fetch(key) < plan.limit(key)
    end

    def has_feature?(feature)
      plan.feature_enabled?(feature)
    end

    private

    def load_plan_from_info(plan_info)
      plan = Planify::Plans.get(plan_info.name).dup

      if plan_info.has_overrides?
        plan.merge! plan_info.overrides_as_plan
      end

      return plan
    end

  end
end