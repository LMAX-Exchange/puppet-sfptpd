require 'spec_helper_acceptance'

describe 'sfptpd::config class' do
  describe 'in freerun mode' do
    it 'sets up sfptpd.conf' do
      pp = <<-EOS
        class { 'sfptpd':
          sync_mode => 'freerun',
        }
      EOS
      # run twice, test for idempotency
      apply_manifest(pp, catch_failures: true)
      expect(apply_manifest(pp, catch_failures: true).exit_code).to be_zero
    end
    describe file('/etc/sfptpd.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(%r{^sync_mode freerun$}) }
      its(:content) { is_expected.to match(%r{^freerun_mode nic$}) }
      its(:content) { is_expected.to match(%r{^ntp_mode off$}) }
      its(:content) { is_expected.to match(%r{^ntp_poll_interval 1$}) }
    end
  end
end
