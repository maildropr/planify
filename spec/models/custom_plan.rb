class CustomPlan
  include Planify::Plan

  def initialize(limits = {}, features = {})
    limits.each do |klass, limit|
      max klass, limit
    end

    features.each { |f, enabled| feature f, enabled }
  end
end