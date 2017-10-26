require 'spec_helper'

describe 'sfptpd::sync_module::pps' do
  context 'on CentOS OS' do
    let(:pre_condition) { [ "class { 'sfptpd': config_file => '/etc/sfptpd.conf' }" ] }
    let(:facts) {{
      :osfamily                => 'RedHat',
      :operatingsystemrelease  => '6.6',
      :operatingsystem         => 'CentOS'
    }}
    let(:title) { 'pps1' }
    let(:params) {{ :interface => 'eth0' }}
    it { should compile }
    it { should contain_concat__fragment('pps_pps1').with_content(/^interface eth0/) }
    it { should contain_concat__fragment('pps_pps1').with_content(/^master_time_source gps/) }
    it { should contain_concat__fragment('pps_pps1').with_content(/^outlier_filter_type std-dev/) }
  end
end
