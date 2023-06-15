require 'spec_helper'

describe 'sfptpd::sync_module::crny' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:pre_condition) { [ "class { 'sfptpd': config_file => '/etc/sfptpd.conf' }" ] }
      let(:title) { 'crny1' }
      let(:params) { { control_script: '/tmp/foo' } }

      it { is_expected.to compile }
      it { is_expected.to contain_concat__fragment('crny_crny1').with_content(%r{^control_script /tmp/foo}) }
    end
  end
end
