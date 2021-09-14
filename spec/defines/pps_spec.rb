require 'spec_helper'

describe 'sfptpd::sync_module::pps' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:pre_condition) { [ "class { 'sfptpd': config_file => '/etc/sfptpd.conf' }" ] }
      let(:title) { 'pps1' }
      let(:params) { { interface: 'eth0' } }

      it { is_expected.to compile }
      it { is_expected.to contain_concat__fragment('pps_pps1').with_content(%r{^interface eth0}) }
      it { is_expected.to contain_concat__fragment('pps_pps1').with_content(%r{^master_time_source gps}) }
      it { is_expected.to contain_concat__fragment('pps_pps1').with_content(%r{^outlier_filter_type std-dev}) }
    end
  end
end
