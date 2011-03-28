# Define it as a plain constant instead of Bundler best-practice of
# Rack::Fontserve::VERSION since Fontserve is a class that inherits from Sinatra::Base
# and we'd be getting Superclass mismatch errors here since Sinatra is
# unavailable when evaluating this file standalone, i.e. in Rakefile
FONTSERVE_VERSION = '0.1.2'