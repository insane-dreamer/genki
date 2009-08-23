class EnkiFormatter
  class << self
    def format_as_xhtml(text)
      Lesstile.format_as_xhtml(
        text,
        :text_formatter => lambda { |text| Moredown.new(CGI::unescapeHTML(text)).to_html},
        :code_formatter => lambda { |code| "<pre class=\"prettyprint\"><code>#{code}</code></pre>" }
      )  
    end
  end
end