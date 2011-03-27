require 'helper'

class FontTest < Test::Unit::TestCase
  should "have a fonts path set" do
    assert Rack::Fontserve.fonts_path =~ /fixtures\/fonts$/
  end
  
  context "Rack::Fontserve::Font.all" do
    setup { @all = Rack::Fontserve::Font.all }
    should("return 3 fonts") { assert_equal 3, @all.count }
    should("have font 'SampleFont'") { assert @all.map(&:name).include?('SampleFont') }
    should("have font 'AnotherFont'") { assert @all.map(&:name).include?('AnotherFont') }
    should("have font 'SimpleFont'") { assert @all.map(&:name).include?('SimpleFont') }
  end
  
  context "the font 'AnotherFont'" do
    setup { @font = Rack::Fontserve::Font.new('AnotherFont') }
    should("have 4 formats") { assert_equal 4, @font.formats.count }
    should("have formats otf, svg, ttf, woff") { assert_equal %w(otf svg ttf woff), @font.formats }
    
    should "return fonts_path/AnotherFont/AnotherFont.otf for format_path('otf')" do 
      assert_equal File.join(Rack::Fontserve.fonts_path, 'AnotherFont/AnotherFont.otf'), @font.format_path('otf')
    end
    
    should "Rack::Fontserve::InvalidFontError for format_path('eot')" do 
      assert_raise Rack::Fontserve::InvalidFormatError do
        @font.format_path('eot')
      end
    end
  end
  
  should "raise Rack::Fontserve::InvalidFontError when trying to load 'InvalidFont'" do
    assert_raise Rack::Fontserve::InvalidFontError do
      Rack::Fontserve::Font.new('InvalidFont')
    end
  end
  
  should "raise Rack::Fontserve::InvalidFontError when trying to load 'MissingFont'" do
    assert_raise Rack::Fontserve::InvalidFontError do
      Rack::Fontserve::Font.new('MissingFont')
    end
  end
  
  should "raise Rack::Fontserve::InvalidFontError when trying to load 'UnexistingFont'" do
    assert_raise Rack::Fontserve::InvalidFontError do
      Rack::Fontserve::Font.new('UnexistingFont')
    end
  end
  
  should "raise Rack::Fontserve::InvalidFontError when trying to load 'FileFont'" do
    assert_raise Rack::Fontserve::InvalidFontError do
      Rack::Fontserve::Font.new('FileFont')
    end
  end
end