require 'spec_helper'

describe 'sfptpd' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
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

      describe 'sfptpd::service' do
        context 'sfptpd::service with defaults' do
          it { should contain_service('sfptpd').with_ensure('running') }
          it { should contain_service('sfptpd').with_enable(true) }
          it { should contain_service('sfptpd').with_hasrestart(true) }
          it { should contain_service('sfptpd').with_hasstatus(true) }
        end

        context ' with different params' do
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

        context 'with manage_service=false' do
          let(:params) {{
            :manage_service => false
          }}
          it { should_not contain_service('sfptpd') }
        end
      end

      describe 'sfptpd::config' do
        it { should contain_concat('/etc/sfptpd.conf').with_owner('0') }
        it { should contain_concat('/etc/sfptpd.conf').with_group('0') }
        it { should contain_concat('/etc/sfptpd.conf').with_mode('0755') }
        it { should contain_concat('/etc/sfptpd.conf').that_notifies('Class[sfptpd::service]') }

        it { should contain_file('/var/log/sfptpd').with_ensure('directory') }

        it { should contain_logrotate__rule('sfptpd') }

        context 'with manage_service=false' do
          let(:params) {{
            :manage_service => false
          }}
          it { should contain_concat('/etc/sfptpd.conf').that_notifies(nil) }
        end

        context 'with manage_logrotate=false' do
          let(:params) {{ :manage_logrotate => false }}
          it { should_not contain_logrotate__rule('sfptpd') }
        end

        context 'with stats_log set' do
          let(:params) {{ :stats_log => '/var/log/sfptpd/sfptpd.stats' }}
          it { should contain_concat__fragment('base').with_content(/^stats_log \/var\/log\/sfptpd\/sfptpd\.stats/) }
          it { should contain_logrotate__rule('sfptpd').with_path(/\/var\/log\/sfptpd\/sfptpd\.stats/) }
        end

        context 'with lots of sync_modules' do
          let(:params) {{
            :sync_module => {
              'ptp' => [ 'ptp1', 'ptp2' ],
              'ntp' => [ 'ntp1' ],
              'freerun' => [ 'fr1' ],
              'pps' => [ 'pps1' ],
            }
          }}
          it { should contain_concat__fragment('base').with_content(/^sync_module ptp ptp1 ptp2/) }
          it { should contain_concat__fragment('base').with_content(/^sync_module ntp ntp1/) }
          it { should contain_concat__fragment('base').with_content(/^sync_module freerun fr1/) }
          it { should contain_concat__fragment('base').with_content(/^sync_module pps pps1/) }
          it { should contain_concat__fragment('base').with_content(/^\[ptp\]/) }
        end
      end
    end
  end
end
