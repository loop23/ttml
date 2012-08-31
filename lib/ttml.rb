require "ttml/version"
require "nokogiri"

module Ttml
  class Document < Nokogiri::XML
    # Returns the subtitle from "from" to "to" as an enumerator
    # (or all subtitles if both are missing)
    def subtitle_stream from = 0.0, to = 99999999.0
      xpath "//p"
    end

    # Returns document title
    def title
      xpath "//ns2::title".text
    end

    # Returns document description
    def title
      xpath "//ns2::description".text
    end

    # Returns document copyright
    def copyright
      xpath "//ns2:copyright".text
    end

  end
end
