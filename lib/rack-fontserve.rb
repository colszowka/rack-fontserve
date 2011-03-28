require 'sinatra/base'

module Rack
  class Fontserve < Sinatra::Base
    class InvalidFontError < StandardError; end;
    class InvalidFormatError < StandardError; end;
    autoload :Font, 'rack-fontserve/font'
    
    CONTENT_TYPES = {'ttf' => 'font/truetype', 
                     'otf' => 'font/opentype', 
                     'woff' => 'font/woff', 
                     'eot' => 'application/vnd.ms-fontobject',
                     'svg' => 'image/svg+xml',
                     'css' => 'text/css;charset=utf-8'}
                     
    set :max_age, 365 * 24 * 60 * 60
    set :views, ::File.join(::File.dirname(__FILE__), 'rack-fontserve/views')
    
    not_found do
      [404, '']
    end
    
    error(InvalidFontError)   { not_found }
    error(InvalidFormatError) { not_found }
    
    helpers do
      def prepare_headers(format)
        set_content_type(format)
        set_cache
      end
      
      def set_content_type(format)
        headers['Content-Type'] = CONTENT_TYPES[format.to_s]
      end
      
      def set_cache
        headers 'Cache-Control' => "public, max-age=#{Rack::Fontserve.max_age}",
                'Expires' => (Time.now + Rack::Fontserve.max_age).httpdate,
                'Access-Control-Allow-Origin' => '*'        
      end
      
      def format?(f)
        @font.formats.include?(f.to_s)
      end
    end
    
    get '/demo' do
      erb :demo
    end
    
    get '/:font_name.css' do
      @font = Font.new(params[:font_name])
      prepare_headers :css
      @font.custom_css? ? @font.custom_css : erb(:stylesheet)
    end
    
    get '/:font_name.:format' do
      @font = Font.new(params[:font_name])
      @data = open(@font.format_path(params[:format]))
      prepare_headers params[:format]
      @data.read
    end
  end
end
