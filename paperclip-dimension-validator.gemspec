# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "paperclip-dimension-validator"
  spec.version       = '0.1.1'
  spec.authors       = ["Anthony Smith"]
  spec.email         = ["anthony@sticksnleaves.com"]
  spec.description   = %q{Validate image height and width for Paperclip}
  spec.summary       = %q{Validate them dimensions!}
  spec.homepage      = "https://github.com/anthonator/paperclip-dimension-validator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'paperclip',    '>= 3.0.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
