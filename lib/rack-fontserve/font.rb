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
    File.join(path, "#{name}.#{format}")
  end
  
  private
  
  def valid?
    formats.count > 0
  end
  
end