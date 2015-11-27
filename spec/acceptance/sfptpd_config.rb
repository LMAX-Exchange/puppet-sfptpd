require 'spec_helper_acceptance'

describe 'sfptpd::config class' do
  describe 'in freerun mode' do
    it 'sets up sfptpd.conf' do
      pp = <<-EOS
        class { 'sfptpd':
          sync_mode => 'freerun',
        }
      EOS
      #run twice, test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
    describe file('/etc/sfptpd.conf') do
      it { should be_file }
      its(:content) { should match /^sync_mode freerun$/ }
      its(:content) { should match /^freerun_mode nic$/ }
      its(:content) { should match /^ntp_mode off$/ }
      its(:content) { should match /^ntp_poll_interval 1$/ }
    end
  end
end
