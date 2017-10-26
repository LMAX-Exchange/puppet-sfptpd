require 'spec_helper'

describe 'sfptpd::sync_module::ntp' do
  context 'on CentOS OS' do
    let(:pre_condition) { [ "class { 'sfptpd': config_file => '/etc/sfptpd.conf' }" ] }
    let(:facts) {{
      :osfamily                => 'RedHat',
      :operatingsystemrelease  => '6.6',
      :operatingsystem         => 'CentOS'
    }}
    let(:title) { 'ntp1' }
    let(:params) {{ :ntp_key => '10 woof' }}
    it { should compile }
    it { should contain_concat__fragment('ntp_ntp1').with_content(/^ntp_key 10 woof/) }
  end
end
