
require_relative 'lib/http/accept/version'

Gem::Specification.new do |spec|
	spec.name          = "http-accept"
	spec.version       = HTTP::Accept::VERSION
	spec.authors       = ["Samuel Williams"]
	spec.email         = ["samuel.williams@oriontransfer.co.nz"]

	spec.summary       = %q{Parse Accept and Accept-Language HTTP headers.}
	spec.homepage      = "https://github.com/ioquatix/http-accept"
	spec.license       = 'MIT'

	spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
	spec.bindir        = "exe"
	spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
	spec.require_paths = ["lib"]

	spec.add_development_dependency "covered"
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "rake", "~> 10.0"
	spec.add_development_dependency "rspec", "~> 3.0"
end
