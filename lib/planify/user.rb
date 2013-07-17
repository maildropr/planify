module Planify
  module User

    def plan=(plan, &block)
      if plan.respond_to? :new
        @plan = plan.new
      else
        @plan = plan
      end
    end

    def plan
      @plan
    end

  end
end