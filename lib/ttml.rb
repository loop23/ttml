require "ttml/version"
require "nokogiri"

module Ttml
  # Minimal Timed Text Markup Language parsing and extraction.
  #
  # Example:
  #   >> doc = Ttml::Document.new('test/sample.xml')
  #   => [Ttml::Document]
  #   >> doc.copyright
  #   => '(c) 2012 loop23'
  #   >> doc.subtitles
  #   => [All subtitles]
  #   >> doc.subtitles(0.0, 100.0)
  #   => [Subtitles from beginning to 100 seconds]
  class Document

    attr_reader :doc, :namespaces

    def initialize file_or_stream
      stream = file_or_stream.is_a?(IO) ? file_or_stream : File.open(file_or_stream)
      @doc = Nokogiri::XML(stream)
      @namespaces = @doc.collect_namespaces
      # puts "Ho namespaces? #{ @namespaces.inspect }"
      @subs_ns = @namespaces.invert["http://www.w3.org/2006/10/ttaf1"]
      @meta_ns = @namespaces.invert["http://www.w3.org/2006/10/ttaf1#metadata"].sub(/^xmlns:/,'')
    end

    # Returns subtitles from "from" to "to" (inclusive) as an array
    # (or all subtitles if both are missing).
    # I tried using xpath functions, without success,
    # as in xmlns:div/xmlns:p[number(@begin)=>746.63] - any ideas?
    def subtitle_stream from = 0.0, to = 99999999.0
      doc.xpath("/#{ @subs_ns }:tt/#{ @subs_ns }:body/#{ @subs_ns }:div/#{ @subs_ns }:p").select {|n|
        # puts "Vedo se #{ n['begin'].to_f } >= #{ from } e se #{ n['end'].to_f } <= #{ to }"
        (n['begin'].to_f >= from) && (n['end'].to_f <= to)
      }
    end

    # Returns document title
    def title
      doc.xpath("//#{ @meta_ns }:title")[0].children[0].content
    end

    # Returns document description
    def description
      doc.xpath("//#{ @meta_ns }:description")[0].children[0].content
    end

    # Returns document copyright
    def copyright
      doc.xpath("//#{ @meta_ns }:copyright")[0].children[0].content
    end

  end
end
