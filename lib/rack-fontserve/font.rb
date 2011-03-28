class Rack::Fontserve::Font
  attr_reader :name
  
  def self.all
    Dir[File.join(Rack::Fontserve.fonts_path.to_s, '*')].map do |path|
      begin
        new(File.basename(path)) 
      rescue Rack::Fontserve::InvalidFontError
        nil
      end  
    end.compact
  end
  
  def initialize(name)
    @name = File.basename(name) # Ensure we remove any path sections that might get burned into here
    raise Rack::Fontserve::InvalidFontError unless valid?
  end
  
  def path
    @path ||= File.join(Rack::Fontserve.fonts_path, name)
  end
  
  def formats
    @formats ||= Dir[File.join(path, "#{name}.{otf,svg,ttf,woff,eot}")].map {|file| File.extname(file)[1..-1] }.sort
  end
  
  def format_path(format)
    raise Rack::Fontserve::InvalidFormatError unless formats.include?(format)
    file_path "#{name}.#{format}"
  end
  
  def custom_css?
    File.exist? file_path("#{name}.css")
  end
  
  def custom_css
    File.read file_path("#{name}.css") if custom_css?
  end
  
  def license?
    File.exist? file_path('LICENSE')
  end
  
  def license
    File.read file_path('LICENSE') if license?
  end
  
  private
  
  def valid?
    formats.count > 0
  end
  
  def file_path(filename)
    File.join(path, filename)
  end
end