require 'spec_helper'

describe 'sfptpd::sync_module::ptp' do
  context 'on CentOS OS' do
    let(:pre_condition) { [ "class { 'sfptpd': config_file => '/etc/sfptpd.conf' }" ] }
    let(:facts) {{
      :osfamily                => 'RedHat',
      :operatingsystemrelease  => '6.6',
      :operatingsystem         => 'CentOS'
    }}
    let(:title) { 'ptp1' }
    let(:params) {{ :interface => 'eth0' }}
    it { should compile }
    it { should contain_concat__fragment('ptp_ptp1').with_content(/^interface eth0/) }
    it { should contain_concat__fragment('ptp_ptp1').with_content(/^ptp_mode slave/) }
    it { should contain_concat__fragment('ptp_ptp1').with_content(/^ptp_delay_mechanism end-to-end/) }
  end
end
