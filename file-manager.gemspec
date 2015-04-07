lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "file-manager"
  spec.version       = '0.0.10'
  spec.authors       = ["Francisco Barroso / Marlus Saraiva"]
  spec.email         = ["franciscobarroso@grupofortes.com.br"]
  spec.description   = 'File manager, access S3 or local'
  spec.summary       = 'File manager, access S3 or local'
  spec.homepage      = ''

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.homepage    = 'https://github.com/fortesinformatica/file-manager'

  spec.add_dependency 'aws-sdk', '~>1.52.0'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
