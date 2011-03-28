require 'helper'

class WebTest < Test::Unit::TestCase
  
  get '/foo' do
    should_respond_with 404
    should("render an empty string") { assert_equal '', last_response.body }
  end
  
  get '/SampleFont.css' do
    should_respond_with 200
    should_set_header 'Content-Type', 'text/css;charset=utf-8'
    should_set_caching
    should_have_rendered_css 'SampleFont'
  end
  
  get '/CustomCSS.css' do
    should_respond_with 200
    should_set_header 'Content-Type', 'text/css;charset=utf-8'
    should_set_caching
    should_have_rendered_css 'CustomCSS'
  end
  
  get '/LicenseFont.css' do
    should_respond_with 200
    should_set_header 'Content-Type', 'text/css;charset=utf-8'
    should_set_caching
    should_have_rendered_css 'LicenseFont'
  end

  %w(eot otf svg ttf woff).each do |format|
    get "/SampleFont.#{format}" do
      should_respond_with 200
      should_set_content_type_for format
      should_set_caching
    end
  end  
  
  %w(otf svg ttf woff).each do |format|
    get "/AnotherFont.#{format}" do
      should_respond_with 200
      should_set_content_type_for format
      should_set_caching
    end
  end
  
  get '/AnotherFont.eot' do
    should_respond_with 404
    should_not_set_caching
  end
  
  %w(eot otf svg woff).each do |format|
    get "/SimpleFont.#{format}" do
      should_respond_with 404
      should_not_set_caching
    end
  end
  
  get '/' do
    should_respond_with 200
    should_set_header 'Content-Type', 'text/html;charset=utf-8'
  end
  
  context "when demo is deactivated" do
    setup do
      Rack::Fontserve.set :demo, false
    end
    
    get '/' do
      should_respond_with 404
      should_not_set_caching
    end
    
    teardown do
      Rack::Fontserve.set :demo, true
    end
  end
end
