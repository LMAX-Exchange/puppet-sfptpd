require 'spec_helper'

describe 'sfptpd::sync_module::freerun' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:pre_condition) { [ "class { 'sfptpd': config_file => '/etc/sfptpd.conf' }" ] }
      let(:title) { 'fr1' }
      let(:params) { { interface: 'eth0' } }

      it { is_expected.to compile }
      it { is_expected.to contain_concat__fragment('freerun_fr1').with_content(%r{^interface eth0}) }
    end
  end
end
