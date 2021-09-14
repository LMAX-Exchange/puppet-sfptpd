require 'spec_helper'

describe 'sfptpd' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('sfptpd::install') }
      it { is_expected.to contain_class('sfptpd::config') }
      it { is_expected.to contain_class('sfptpd::service') }

      describe 'sfptpd::install with defaults' do
        it { is_expected.to contain_package('sfptpd').with_ensure('installed') }
      end

      describe 'sfptpd::install with different params' do
        let(:params) do
          {
            package_name: 'sfptpd2',
            package_ensure: 'absent'
          }
        end

        it { is_expected.to contain_package('sfptpd2').with_ensure('absent') }
      end

      describe 'sfptpd::service' do
        context 'sfptpd::service with defaults' do
          it { is_expected.to contain_service('sfptpd').with_ensure('running') }
          it { is_expected.to contain_service('sfptpd').with_enable(true) }
          it { is_expected.to contain_service('sfptpd').with_hasrestart(true) }
          it { is_expected.to contain_service('sfptpd').with_hasstatus(true) }
        end

        context ' with different params' do
          let(:params) do
            {
              service_name: 'sfptpd2',
              service_ensure: 'stopped',
              service_enable: false,
              service_hasstatus: false,
              service_hasrestart: false
            }
          end

          it { is_expected.to contain_service('sfptpd2').with_ensure('stopped') }
          it { is_expected.to contain_service('sfptpd2').with_enable(false) }
          it { is_expected.to contain_service('sfptpd2').with_hasrestart(false) }
          it { is_expected.to contain_service('sfptpd2').with_hasstatus(false) }
        end

        context 'with manage_service=false' do
          let(:params) do
            {
              manage_service: false
            }
          end

          it { is_expected.not_to contain_service('sfptpd') }
        end
      end

      describe 'sfptpd::config' do
        it { is_expected.to contain_concat('/etc/sfptpd.conf').with_owner('0') }
        it { is_expected.to contain_concat('/etc/sfptpd.conf').with_group('0') }
        it { is_expected.to contain_concat('/etc/sfptpd.conf').with_mode('0755') }
        it { is_expected.to contain_concat('/etc/sfptpd.conf').that_notifies('Class[sfptpd::service]') }

        it { is_expected.to contain_file('/var/log/sfptpd').with_ensure('directory') }

        it { is_expected.to contain_logrotate__rule('sfptpd') }

        context 'with manage_service=false' do
          let(:params) do
            {
              manage_service: false
            }
          end

          it { is_expected.to contain_concat('/etc/sfptpd.conf').that_notifies(nil) }
        end

        context 'with manage_logrotate=false' do
          let(:params) { { manage_logrotate: false } }

          it { is_expected.not_to contain_logrotate__rule('sfptpd') }
        end

        context 'with stats_log set' do
          let(:params) { { stats_log: '/var/log/sfptpd/sfptpd.stats' } }

          it { is_expected.to contain_concat__fragment('sfptpd_base').with_content(%r{^stats_log /var/log/sfptpd/sfptpd\.stats}) }
          it { is_expected.to contain_logrotate__rule('sfptpd').with_path(%r{/var/log/sfptpd/sfptpd\.stats}) }
        end

        context 'with lots of sync_modules' do
          let(:params) do
            {
              sync_module: {
                ptp:  [ 'ptp1', 'ptp2' ],
                ntp:  [ 'ntp1' ],
                freerun:  [ 'fr1' ],
                pps: [ 'pps1' ],
              }
            }
          end

          it { is_expected.to contain_concat__fragment('sfptpd_base').with_content(%r{^sync_module ptp ptp1 ptp2}) }
          it { is_expected.to contain_concat__fragment('sfptpd_base').with_content(%r{^sync_module ntp ntp1}) }
          it { is_expected.to contain_concat__fragment('sfptpd_base').with_content(%r{^sync_module freerun fr1}) }
          it { is_expected.to contain_concat__fragment('sfptpd_base').with_content(%r{^sync_module pps pps1}) }
          it { is_expected.to contain_concat__fragment('sfptpd_base').with_content(%r{^\[ptp\]}) }
        end
      end
    end
  end
end
