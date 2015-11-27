require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
Rake::Task[:lint].clear
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('relative')
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]


desc "Validate manifests, templates, and ruby files"
task :validate do
  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['spec/**/*.rb','lib/**/*.rb'].each do |ruby_file|
    sh "ruby -c #{ruby_file}" unless ruby_file =~ /spec\/fixtures/
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end

desc "Run beaker acceptance tests on a single spec file"
RSpec::Core::RakeTask.new(:beakerfile, :file) do |t, task_args|
  t.rspec_opts = ['--color']
  t.pattern = "spec/acceptance/#{task_args[:file]}"
end

desc "Run spec tests on a single spec/classes/something_spec.rb spec file"
RSpec::Core::RakeTask.new(:single, :file) do |t, task_args|
  Rake::Task[:spec_prep].invoke
  t.rspec_opts = ['--color']
  t.pattern = "spec/{classes,defines}/#{task_args[:file]}"
end
