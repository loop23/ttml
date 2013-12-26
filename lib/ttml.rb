require "ttml/version"
require "nokogiri"

module Ttml

  # Some stuff that helps but is not directly about getting nodes out of it
  class Util
    # takes a string offset (as found in ttml nodes) and returns smpte string;
    # Used in converting to SubRip.
    #
    # Ex: 0.0s => 00:00:00.0
    # Ex: 63.5s => 00:01:03.500
    def self.smpte_time offset
      hours = minutes = seconds = millisecs = 0
      f_off = offset.to_s.sub(/s$/, '').to_f
      millisecs = ((f_off - f_off.to_i) * 1000).to_i
      minutes, seconds = f_off.divmod(60)
      hours, minutes = minutes.divmod(60)
      "#{ sprintf('%02d', hours) }:#{ sprintf('%02d', minutes) }:#{ sprintf('%02d', seconds) },#{ millisecs }"
    end
  end
  # Minimal Timed Text Markup Language parsing and extraction.
  #
  # Example:
  #   >> doc = Ttml::Document.new('test/sample.xml')
  #   => [Ttml::Document]
  #   >> doc.copyright
  #   => '(c) 2012 loop23'
  #   >> doc.subtitle_stream
  #   => [All subtitles as Nokogiri::Node instances]
  #   >> doc.subtitle_stream(0.0, 100.0)
  #   => [Subtitles from beginning to 100 seconds]
  class Document

    attr_reader :doc, :namespaces

    def initialize file_or_stream
      stream = file_or_stream.is_a?(IO) ? file_or_stream : File.open(file_or_stream)
      @doc = Nokogiri::XML(stream)
      @namespaces = @doc.collect_namespaces
      # puts "Ho namespaces? #{ @namespaces.inspect }"
      @subs_ns = @namespaces.invert["http://www.w3.org/2006/10/ttaf1"].sub(/^xmlns:/,'')
      @meta_ns = @namespaces.invert["http://www.w3.org/2006/10/ttaf1#metadata"].sub(/^xmlns:/,'')
    end

    # Returns subtitles from "from" to "to" (inclusive) as an array
    # (or all subtitles if both are missing).
    # I tried using xpath functions, without success,
    # as in xmlns:div/xmlns:p[number(@begin)=>746.63] - any ideas?
    def subtitle_stream from = 0.0, to = nil
      to = 99999999999.99 unless to
      @all_subs ||= doc.xpath("/#{ @subs_ns }:tt/#{ @subs_ns }:body/#{ @subs_ns }:div/#{ @subs_ns }:p")
      @all_subs.select {|n|
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
