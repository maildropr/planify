require "planify/util/class_helper"

module Planify
  module User
    include Planify::ClassHelper

    class PlanInfo
      include Mongoid::Document

      field :name, type: String, default: nil
      field :limit_overrides, type: Hash, default: nil
      field :feature_overrides, type: Hash, default: nil

      def has_overrides?
        limit_overrides.present? || feature_overrides.present?
      end
    end

    def self.included(base)
      base.class_eval do
        embeds_one :plan_info, class_name: "Planify::User::PlanInfo"
      end
    end

    def has_plan(plan_name, &block)
      @plan = Planify::Plans.get(plan_name)
      self.plan_info = PlanInfo.new(name: plan_name)

      if block_given?
        @plan = @plan.dup
        @configuration = Planify::Plan.new
        @configuration.instance_eval &block

        @plan.merge! @configuration

        self.plan_info.limit_overrides = @configuration.limits.all
        self.plan_info.feature_overrides = @configuration.features
      end
    end

    def plan
      @plan ||= load_plan_from_info(self.plan_info)
    end

    private

    def load_plan_from_info(plan_info)
      plan = Planify::Plans.get(plan_info.name)

      if plan_info.has_overrides?
        plan = dup_with_overrides(plan, 
                                  plan_info.limit_overrides, 
                                  plan_info.feature_overrides)
      end

      return plan
    end

    def dup_with_overrides(plan, limit_overrides, feature_overrides)
      plan = plan.dup

      plan.tap do |p|
        limit_overrides.try(:each) do |klass, limit|
          p.max klass, limit
        end

        feature_overrides.try(:each) do |f, enabled|
          p.feature f, enabled
        end
      end
    end

  end
end