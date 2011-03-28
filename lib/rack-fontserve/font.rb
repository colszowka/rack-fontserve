# Representation of fonts in the Rack::Fontserve.fonts_path, including various
# helpers to check and retrieve formats, license and custom css
class Rack::Fontserve::Font
  attr_reader :name
  
  # Returns an array of all present and valid fonts
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
  
  # Returns the base path of this font
  def path
    @path ||= File.join(Rack::Fontserve.fonts_path, name)
  end
  
  # Retruns a list of available formats
  def formats
    @formats ||= Dir[File.join(path, "#{name}.{otf,svg,ttf,woff,eot}")].map {|file| File.extname(file)[1..-1] }.sort
  end
  
  # Returns the path to the font file in given format. Raises InvalidFormatError if the font is not available in this format
  def format_path(format)
    raise Rack::Fontserve::InvalidFormatError unless formats.include?(format)
    file_path "#{name}.#{format}"
  end
  
  # custom css file exists?
  def custom_css?
    File.exist? file_path("#{name}.css")
  end
  
  # Returns the content of the custom CSS file if present, nil otherwise
  def custom_css
    File.read file_path("#{name}.css") if custom_css?
  end
  
  # LICENSE file exists?
  def license?
    File.exist? file_path('LICENSE')
  end
  
  # Returns the content of the LICENSE file if present, nil otherwise
  def license
    File.read file_path('LICENSE') if license?
  end
  
  private
  
  # Checks whether this font is valid - which is the case when the font has any formats present
  def valid?
    formats.count > 0
  end
  
  # Helper for paths to files in the font's home dir
  def file_path(filename)
    File.join(path, filename)
  end
end