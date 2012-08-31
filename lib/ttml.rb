require "ttml/version"
require "nokogiri"

module Ttml
  class Document < Nokogiri::Document
    def subtitle_stream
      raise "Unimplemented!"
    end
  end
end
