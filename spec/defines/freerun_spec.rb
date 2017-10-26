require 'spec_helper'

describe 'sfptpd::sync_module::freerun' do
  context 'on CentOS OS' do
    let(:pre_condition) { [ "class { 'sfptpd': config_file => '/etc/sfptpd.conf' }" ] }
    let(:facts) {{
      :osfamily                => 'RedHat',
      :operatingsystemrelease  => '6.6',
      :operatingsystem         => 'CentOS'
    }}
    let(:title) { 'fr1' }
    let(:params) {{ :interface => 'eth0' }}
    it { should compile }
    it { should contain_concat__fragment('freerun_fr1').with_content(/^interface eth0/) }
  end
end
