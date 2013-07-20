require "mongoid"
require "active_support"

require "planify/limitations"
require "planify/plan"
require "planify/plans"
require "planify/user"

require "planify/railtie" if defined?(Rails)

module Planify
  module Limitable; end
end
