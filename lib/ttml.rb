require "ttml/version"
require "nokogiri"

module Ttml
  class Document

    attr_reader :doc

    def initialize file_or_stream
      stream = file_or_stream.is_a?(IO) ? file_or_stream : File.open(file_or_stream)
      @doc = Nokogiri::XML(stream)
    end

    # Returns subtitles from "from" to "to" as an array
    # (or all subtitles if both are missing).
    # I tried using xpath functions, without success,
    # as in xmlns:div/xmlns:p[number(@begin)=>746.63] - any ideas?
    def subtitle_stream from = 0.0, to = 99999999.0
      doc.xpath("/xmlns:tt/xmlns:body/xmlns:div/xmlns:p").select {|n|
        # puts "Vedo se #{ n['begin'].to_f } >= #{ from } e se #{ n['end'].to_f } <= #{ to }"
        (n['begin'].to_f >= from) && (n['end'].to_f <= to)
      }
    end

    # Returns document title
    def title
      doc.xpath("//ns2:title")[0].children[0].content
    end

    # Returns document description
    def description
      doc.xpath("//ns2:description")[0].children[0].content
    end

    # Returns document copyright
    def copyright
      doc.xpath("//ns2:copyright")[0].children[0].content
    end

  end
end
