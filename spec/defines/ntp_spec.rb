require 'spec_helper'

describe 'sfptpd::sync_module::ntp' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:pre_condition) { [ "class { 'sfptpd': config_file => '/etc/sfptpd.conf' }" ] }
      let(:title) { 'ntp1' }
      let(:params) { { ntp_key: '10 woof' } }

      it { is_expected.to compile }
      it { is_expected.to contain_concat__fragment('ntp_ntp1').with_content(%r{^ntp_key 10 woof}) }
    end
  end
end
