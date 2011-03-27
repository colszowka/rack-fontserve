ENV['RACK_ENV'] = 'test'
require 'rubygems'
require 'bundler/setup'
require 'rack-fontserve'

require 'test/unit'
require 'shoulda'
require 'rack/test'

Rack::Fontserve.set :fonts_path, File.join(File.dirname(__FILE__), 'fixtures/fonts')

class Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    Rack::Fontserve
  end
  
  # Shortcut for making requests
  def self.request(http_method, path)
    raise ArgumentError, "Must be get, post, put or delete" unless %w(get post put delete).include?(http_method)
    
    context "#{http_method} '#{path}'" do
      setup { self.send(http_method, path) }
      yield
    end
  end
  
  def self.get(path, &blk)
    request('get', path, &blk)
  end
  
  def self.post(path, &blk)
    request('post', path, &blk)
  end
  
  def self.should_respond_with(status)
    should("respond with #{status}") { assert_equal status, last_response.status }
  end
  
  def self.should_set_content_type_for(format)
    formats = {'ttf' => 'font/truetype', 
               'otf' => 'font/opentype', 
               'woff' => 'font/woff', 
               'eot' => 'application/vnd.ms-fontobject',
               'svg' => 'image/svg+xml',
               'css' => 'text/css'
              }
    should_set_header 'Content-Type', formats[format.to_s]
  end
  
  def self.should_set_header(name, value)
    should "set header '#{name}' to '#{value}'" do
      assert_equal value, last_response.headers[name]
    end
  end
  
  def self.should_set_caching
    should_set_header 'Cache-Control', 'public, max-age=31536000'
    
    should "have set 'Expires' to '#{(Time.now + Rack::Fontserve.max_age).httpdate}'" do
      assert_equal((Time.now + Rack::Fontserve.max_age).httpdate, last_response.headers['Expires'])
    end
    
    should "have set 'Access-Control-Allow-Origin' to '*'" do
      assert_equal '*', last_response.headers['Access-Control-Allow-Origin']
    end
  end
  
  def self.should_not_set_caching
    should "not have set 'Cache-Control' header" do
      assert_nil last_response.headers['Cache-Control']
    end
    
    should "not have set 'Expires' header" do
      assert_nil last_response.headers['Expires']
    end
    
    should "not have set 'Access-Control-Allow-Originl' header" do
      assert_nil last_response.headers['Access-Control-Allow-Origin']
    end
  end
  
  def self.should_have_rendered_css(filename)
    should "have rendered the body as expected in fixtures/#{filename}.css" do
      puts last_response.body
      assert_equal File.read(File.join(File.dirname(__FILE__), 'fixtures', "#{filename}.css")), last_response.body
    end
  end
end
