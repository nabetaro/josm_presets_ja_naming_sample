# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'josm_presets_ja_naming_sample/version'

Gem::Specification.new do |spec|
  spec.name          = "josm_presets_ja_naming_sample"
  spec.version       = JosmPresetsJaNamingSample::VERSION
  spec.authors       = ["KURASAWA Nozomu"]
  spec.email         = ["nabetaro@caldron.jp"]
  spec.description   = %q{Transscript wiki to JOSM Presets for JA:Naming_Sample}
  spec.summary       = %q{Transscript wiki to JOSM Presets for JA:Naming_Sample}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "nokogiri"
end
