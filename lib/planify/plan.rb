module Planify

  # The +Planify::Plan+ class provides functionality for storing class creation limits and available features. It also embodies a simple DSL for defining these attributes.
  class Plan

    attr_reader :features, :limits

    def initialize(limits = {}, features = {})
      @limits = Limitations.new(limits)
      @features = features
    end

    def max(klass, limit)
      @limits.set(klass, limit)
    end

    # Gets the plan's limit for a given class constant
    # @param [String,Symbol,Class,Object] klass The class to get the limit for
    # @return [Integer, Float::INFINITY] The plan limit for +klass+, if one exists. Otherwise +Float::INFINITY+
    def limit(klass)
      @limits.get(klass)
    end

    def feature(feature_name, enabled = true) 
      @features[feature_name.to_sym] = enabled
    end

    # Boolean method for determining if a certain feature is enabled in this plan
    # @param [String,Symbol] feature the feature to check
    # @return [Boolean] +true+ if +feature+ is enabled, +false+ if +feature+ is disabled or undefined.
    def feature_enabled?(feature)
      @features[feature.to_sym] || false
    end

    # Boolean method for determining if a certain feature is disabled in this plan
    # @param [String,Symbol] feature the feature to check
    # @return [Boolean] +true+ if +feature+ is disabled or undefined, +false+ if +feature+ is enabled.
    def feature_disabled?(feature)
      !feature_enabled?(feature)
    end

    # Returns a duplicate instance of this plan
    # @return [Planify::Plan] an exact copy of this plan
    def dup
      duplicate = Plan.new
      duplicate.merge! self

      duplicate
    end

    # Merges limits and features from +other_plan+ into self.
    # @param [Planify::Plan] other_plan the plan to merge with
    # @return [nil]
    def merge!(other_plan)
      other_plan.features.each do |f, enabled|
        feature f, enabled
      end

      other_plan.limits.all.each do |klass, lim|
        max klass, lim
      end

      nil
    end

  end
end