class EnkiFormatter
  class << self
    def format_as_xhtml(text)
      Lesstile.format_as_xhtml(
        text,
        :text_formatter => lambda { |text| Moredown.new(CGI::unescapeHTML(text)).to_html},
        :code_formatter => lambda do |code, language|
          unless language
            "<pre><code>#{code}</code></pre>"
          else
            "<pre class=\"prettyprint #{language}\"><code>#{code}</code></pre>"
          end
        end
      )  
    end
  end
end