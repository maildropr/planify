$: << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require "mongoid"
require "rspec"
require "pry"

require "planify"

MODELS = File.join(File.dirname(__FILE__), "models")
Dir[ File.join(MODELS, "*.rb") ].sort.each { |f| require f }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  config.before :all do
    Planify::Plans.define :starter do
      max Post, 100
    end
  end
  
end
