# frozen_string_literal: true

module Low
  class MissingFileError < StandardError; end

  class FileQuery
    class << self
      def file_path(klass:)
        file_path = Object.const_source_location(klass.name).first

        return file_path if File.exist?(file_path)

        raise MissingFileError, "No file found at path '#{file_path}'"
      end
    end
  end
end
