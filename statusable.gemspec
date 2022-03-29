require File.expand_path('lib/statusable/version',__dir__)

Gem::Specification.new do |s|
  s.name               = "statusable"
  s.version            = "1.0.2"
  s.default_executable = "statusable"
  s.authors = ["Saad Ali"]
  s.email = 'saad.ali@empglabs.com'
  s.summary = 'Statusable Module'
  s.description = 'This beautiful gem helps you set status along with Dispositions'
  s.homepage = 'https://rubygems.org/gems/statusable'
  s.license = 'MIT'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>=2.5.0'
  s.files = Dir['README.md', 'LICENSE',
                'CHANGELOG.md', 'lib/**/*.rb',
                'lib/**/**/**/*.rb','lib/**/**/**/**/*.erb',
                'lib/**/*.rake',
                'create_dynamic_fields_rails.gemspec', '.github/*.md',
                'Gemfile', 'Rakefile']
  s.add_development_dependency 'default_value_for'
end
