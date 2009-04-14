require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('freec', '0.1.0') do |p|
  p.description    = "Layer between your voice app and Freeswitch."
  p.url            = "http://github.com/jankubr/freec"
  p.author         = "Jan Kubr"
  p.email          = "hi@jankubr.com"
  p.ignore_pattern = []
  p.runtime_dependencies = ['daemons', 'eventmachine', 'extlib']
  p.development_dependencies = ['rspec']
end

spec = Gem::Specification.new do |s| 
  s.name              = "freec"
  s.version           = '0.1.0'
  s.author            = "Jan Kubr"
  s.email             = "hi@jankubr.com"
  s.homepage          = "http://github.com/jankubr/freec"
  s.platform          = Gem::Platform::RUBY
  s.summary           = "Layer between your voice app and Freeswitch."
  s.files             = FileList["README*",
                                 "Rakefile",
                                 "{lib,spec}/**/*"].to_a
  s.require_path      = "lib"
  #s.test_files        = FileList["test/**/test_*.rb"].to_a
  s.rubyforge_project = "freec"
  s.has_rdoc          = false
  s.extra_rdoc_files  = FileList["README*"].to_a
  s.rdoc_options << '--line-numbers' << '--inline-source'
  s.requirements << "daemons"
  s.add_runtime_dependency 'eventmachine'
  s.add_runtime_dependency 'extlib'
  s.add_development_dependency 'rspec'
end

desc "Generate a gemspec file for GitHub"
task :gemspec do
  File.open("#{spec.name}.gemspec", 'w') do |f|
    f.write spec.to_ruby
  end
end
require 'spec/rake/spectask'

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*.rb']
end