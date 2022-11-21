lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rocketmq-client-ruby/version"

Gem::Specification.new do |s|
  s.name = "rocketmq-client-ruby"
  s.version = Rocketmq::VERSION
  s.authors = ["EdmondFrank"]
  s.email = %w{edmomdfrank@yahoo.com}
  s.description = "A Ruby FFI binding to librocketmq-client-cpp."
  s.summary = s.description
  s.homepage = "https://github.com/edmondfrank/rocketmq-client-ruby"
  s.license = "MIT-2.0"

  s.files = %w{ LICENSE } + Dir.glob("lib/**/*", File::FNM_DOTMATCH).reject { |f| File.directory?(f) }
  s.require_paths = %w{lib}
  s.required_ruby_version = ">= 2.5"

  s.add_dependency "ffi", "~> 1.0"
end
