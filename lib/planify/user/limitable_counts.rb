module Planify
  module User

    class LimitableCounts
      include Mongoid::Document

      embedded_in :planify_user, polymorphic: true

      def increment(limitable)
        self.inc(limitable, 1)
      end

      def decrement(limitable)
        self.inc(limitable, -1)
      end

      def fetch(limitable, default = 0)
        self.attributes[limitable] || default
      end
    end

  end
end
