require 'spec_helper'

describe 'sfptpd' do
  context 'on CentOS OS' do
    let (:facts) {{
      :osfamily                => 'RedHat',
      :operatingsystemrelease  => '6.6',
      :operatingsystem         => 'CentOS'
    }}
    it { should compile }
    it { should contain_class('sfptpd::install') }
    it { should contain_class('sfptpd::config') }
    it { should contain_class('sfptpd::service') }

    describe 'sfptpd::install with defaults' do
      it { should contain_package('sfptpd').with_ensure('installed') }
    end

    describe 'sfptpd::install with different params' do
      let(:params) {{
        :package_name   => 'sfptpd2',
        :package_ensure => 'absent'
      }}
      it { should contain_package('sfptpd2').with_ensure('absent') }
    end

    describe 'sfptpd::service with defaults' do
      it { should contain_service('sfptpd').with_ensure('running') }
      it { should contain_service('sfptpd').with_enable(true) }
      it { should contain_service('sfptpd').with_hasrestart(true) }
      it { should contain_service('sfptpd').with_hasstatus(true) }
    end

    describe 'sfptpd::service with different params' do
      let(:params) {{
        :service_name       => 'sfptpd2',
        :service_ensure     => 'stopped',
        :service_enable     => false,
        :service_hasstatus  => false,
        :service_hasrestart => false
      }}
      it { should contain_service('sfptpd2').with_ensure('stopped') }
      it { should contain_service('sfptpd2').with_enable(false) }
      it { should contain_service('sfptpd2').with_hasrestart(false) }
      it { should contain_service('sfptpd2').with_hasstatus(false) }
    end

    describe 'sfptpd::service with manage_service=false' do
      let(:params) {{
        :manage_service => false
      }}
      it { should_not contain_service('sfptpd') }
    end

    describe 'sfptpd::config' do
      it { should contain_file('/etc/sfptpd.conf').with_owner('0') }
      it { should contain_file('/etc/sfptpd.conf').with_group('0') }
      it { should contain_file('/etc/sfptpd.conf').with_mode('0755') }
      it { should contain_file('/etc/sfptpd.conf').that_notifies('Class[sfptpd::service]') }

      it { should contain_file('/etc/init.d/sfptpd').with_owner('0') }
      it { should contain_file('/etc/init.d/sfptpd').with_group('0') }
      it { should contain_file('/etc/init.d/sfptpd').with_mode('0755') }

      it { should contain_file('/var/log/sfptpd').with_ensure('directory') }

      it { should contain_logrotate__rule('sfptpd') }

      describe 'with manage_service=false' do
        let(:params) {{
          :manage_service => false
        }}
        it { should contain_file('/etc/sfptpd.conf').that_notifies(nil) }
      end

      describe 'with parameter sync_mode' do
        context 'set to freerun' do
          let(:params) {{ :sync_mode => 'freerun' }}
          it { should contain_file('/etc/sfptpd.conf').with_content(/^sync_mode freerun/) }
          it { should contain_file('/etc/sfptpd.conf').with_content(/^freerun_mode nic/) }
          it { should contain_file('/etc/sfptpd.conf').with_content(/^ntp_mode off/) }
          it { should contain_file('/etc/sfptpd.conf').with_content(/^ntp_poll_interval 1/) }
          it { should contain_file('/etc/sfptpd.conf').with_content(/^stats_log off/) }
        end
        context 'set to ptp' do
          let(:params) {{ :sync_mode => 'ptp' }}
          it { should contain_file('/etc/sfptpd.conf').with_content(/^sync_mode ptp/) }
        end
      end

      describe 'with manage_init_script=false' do
        let(:params) {{ :manage_init_script => false }}
        it { should_not contain_file('/etc/init.d/sfptpd') }
      end

      describe 'with manage_logrotate=false' do
        let(:params) {{ :manage_logrotate => false }}
        it { should_not contain_logrotate__rule('sfptpd') }
      end

      describe 'with stats_log_enable=true' do
        let(:params) {{ :stats_log_enable => true }}
        it { should contain_file('/etc/sfptpd.conf').with_content(/^stats_log \/var\/log\/sfptpd\/stats\.log/) }
      end

      describe 'with a different stats_log_file' do
          let(:params) {{ :stats_log_enable => true, :stats_log_file => '/tmp/foo' }}
          it { should contain_file('/etc/sfptpd.conf').with_content(/^stats_log \/tmp\/foo/) }
      end

      describe 'with adjusted ptp_sync_pkt_interval' do
        let(:params) {{ :ptp_sync_pkt_interval => -2 }}
        it { should contain_file('/etc/sfptpd.conf').with_content(/^ptp_sync_pkt_interval -2$/) }
      end
    end
  end
end
