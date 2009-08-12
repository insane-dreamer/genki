class EnkiFormatter
  class << self
    def format_as_xhtml(text)
      BlueCloth.new(text).to_html
    end
  end
end
