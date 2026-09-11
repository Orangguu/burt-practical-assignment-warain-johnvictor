require 'json'

module DataLoader
    def self.load_json(path)
        JSON.parse(File.read(path))

    rescue Errno::ENOENT
        raise "Error: File not found: #{path}"

    rescue JSON::ParserError
        raise "Error: Invalid JSON in #{path}"
        
    end
end