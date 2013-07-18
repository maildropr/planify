module Planify
  module User

    class PlanInfo
      include Mongoid::Document

      embedded_in :planify_user, polymorphic: true

      field :name, type: String, default: nil
      field :limit_overrides, type: Hash, default: nil
      field :feature_overrides, type: Hash, default: nil

      def has_overrides?
        limit_overrides.present? || feature_overrides.present?
      end

      def overrides_as_plan
        Plan.new.tap do |p|
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
end