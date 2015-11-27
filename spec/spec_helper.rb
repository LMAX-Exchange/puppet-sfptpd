require 'puppetlabs_spec_helper/module_spec_helper'
RSpec.configure do |c|
  #c.fail_fast = true

  # Enable disabling of tests
  c.filter_run_excluding :broken => true
end
