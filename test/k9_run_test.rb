gem 'minitest'      # don't use bundled minitest
require 'minitest/autorun'
require 'minitest/pride'

Dir.chdir(File.dirname(__FILE__))

class Rp5Test < Minitest::Test


  def test_sketch_path
    out, _err = capture_io do
      open('|../bin/k9 run sketches/sketch_path.rb', 'r') do |io|
        while l = io.gets
          puts(l.chop)
        end
      end
    end
    assert_match(/dummy/, out, 'Failed Sketch Path')
  end

end

 

