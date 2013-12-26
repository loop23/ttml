#!/usr/bin/env ruby
require 'test/unit'
require 'ttml'

class TtmlTest < Test::Unit::TestCase

  def setup
    @doc = Ttml::Document.new(File.join(File.dirname(__FILE__), 'sample.xml'))
  end

  def test_class
    assert @doc.is_a?(Ttml::Document)
  end

  def test_copyright
    assert_equal '2012 (c) loop', @doc.copyright
  end

  def test_title
    assert_equal 'Timed Text DFPX', @doc.title
  end

  def test_subs_no_param
    assert @doc.subtitle_stream.is_a?(Array)
  end

  def test_subs_start_param
    assert @doc.subtitle_stream(99999999.0).empty?
    assert_equal 1, @doc.subtitle_stream(746.0).size
  end

  def test_subs_end_param
    assert @doc.subtitle_stream(0.0, 0.0).empty?
    assert_equal 1, @doc.subtitle_stream(746.63, 749.38).size
  end

  def test_other_file
    # (with different namespaces)
    doc = Ttml::Document.new(File.join(File.dirname(__FILE__), 'sample_2.xml'))
    assert_equal 'Timed Text DFPX', doc.title
    assert @doc.subtitle_stream.is_a?(Array)
  end

end
