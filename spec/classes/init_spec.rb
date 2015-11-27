require 'spec_helper'
describe 'sfptpd' do

  context 'with defaults for all parameters' do
    it { should contain_class('sfptpd') }
  end
end
