require 'helper'

class FontTest < Test::Unit::TestCase
  should "have a fonts path set" do
    assert Rack::Fontserve.fonts_path =~ /fixtures\/fonts$/
  end
  
  context "Rack::Fontserve::Font.all" do
    setup { @all = Rack::Fontserve::Font.all }
    should("return 3 fonts") { assert_equal 5, @all.count }
    should("have font 'SampleFont'") { assert @all.map(&:name).include?('SampleFont') }
    should("have font 'AnotherFont'") { assert @all.map(&:name).include?('AnotherFont') }
    should("have font 'SimpleFont'") { assert @all.map(&:name).include?('SimpleFont') }
    should("have font 'CustomCSS'") { assert @all.map(&:name).include?('CustomCSS') }
    should("have font 'LicenseFont'") { assert @all.map(&:name).include?('LicenseFont') }
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
    
    should "not have custom_css?" do
      assert !@font.custom_css?
    end
    should "have nil for custom_css" do
      assert_nil @font.custom_css
    end
    
    should "not have license?" do
      assert !@font.license?
    end
    should "have nil for license" do
      assert_nil @font.license
    end
  end
  
  context "the font 'CustomCSS'" do
    setup { @font = Rack::Fontserve::Font.new('CustomCSS') }
    should("have 1 format") { assert_equal 1, @font.formats.count }
    should("have format ttf") { assert_equal 'ttf', @font.formats.first }
    
    should "have custom css" do
      assert @font.custom_css?
    end
    should "return custom_css" do
      assert_equal @font.custom_css, File.read(File.join(File.dirname(__FILE__), 'fixtures', "CustomCSS.css"))
    end
    
    should "not have license?" do
      assert !@font.license?
    end
    should "have nil for license" do
      assert_nil @font.license
    end
    
    should "return fonts_path/CustomCSS/CustomCSS.ttf for format_path('ttf')" do 
      assert_equal File.join(Rack::Fontserve.fonts_path, 'CustomCSS/CustomCSS.ttf'), @font.format_path('ttf')
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