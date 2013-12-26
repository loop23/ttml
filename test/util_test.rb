#!/usr/bin/env ruby
require 'test/unit'
require 'ttml'

class UtilTest < Test::Unit::TestCase

  def test_smpte
    assert_equal "00:00:00,0", Ttml::Util.smpte_time('0s')
    assert_equal "00:00:00,0", Ttml::Util.smpte_time('0.0s')
    assert_equal "00:01:00,0", Ttml::Util.smpte_time('60.0s')
    assert_equal "00:01:01,0", Ttml::Util.smpte_time('61.0s')
    assert_equal "00:00:00,500", Ttml::Util.smpte_time('0.5s')
  end

end
