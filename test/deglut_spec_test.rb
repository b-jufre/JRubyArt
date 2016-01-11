gem 'minitest' # don't use bundled minitest
require 'java'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/rpextras'

Java::MonkstoneFastmath::DeglutLibrary.new.load(JRuby.runtime, false)

Dir.chdir(File.dirname(__FILE__))

class DeglutTest < Minitest::Test
  attr_reader :to_radian

  def setup
    @to_radian = Math::PI / 180
  end

  def test_cos_sin
    (-720..720).step(1) do |deg|
      sine = DegLut.sin(deg)
      deg_sin = Math.sin(deg * to_radian)
      assert_in_delta(sine, deg_sin)
      cosine = DegLut.cos(deg)
      deg_cos = Math.cos(deg * to_radian)
      assert_in_delta(cosine, deg_cos)
    end
  end
end
