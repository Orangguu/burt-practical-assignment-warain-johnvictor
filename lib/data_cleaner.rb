require "date"

module DataCleaner
    def self.parse_string(raw)
        return nil if raw.nil?

        str = raw.to_s.strip
        str.empty? ? nil : str
    end

    def self.parse_int(raw)
        return nil if raw.nil?
        return raw if raw.is_a?(Integer)

        str = raw.to_s.strip.delete(",")

        return nil if str.empty?

        Integer(str)
        rescue ArgumentError
        nil
    end

    def self.parse_float(raw)
        return nil if raw.nil?
        return raw.to_f if raw.is_a?(Numeric)

        str = raw.to_s.strip.delete(",")
        str = str.sub(/\A[$€£₱¥]/, "")

        return nil if str.empty?

        Float(str)
        rescue ArgumentError
        nil
    end

    def self.parse_date(raw)
        return nil if raw.nil?

        str = raw.to_s.strip
        return nil if str.empty?

        begin
            Date.parse(str)
        rescue ArgumentError
            nil
        end
    end

    def self.format_date(raw)
        date = parse_date(raw)
        date ? date.strftime("%Y-%m-%d") : nil
    end
    
end