module Planify
  module Integrations

    module Rails
      module Helpers
        def limit_exceeded!
          raise "Limit exceeded"
        end

        def enforce_limit!(user, limitable)
          limit_exceeded! unless user.may_create?(limitable)
        end
      end
    end

  end
end