# frozen_string_literal: true

module Low
  class MissingFileError < StandardError; end

  class FileQuery
    class << self
      def file_path(klass:)
        includer_line = line_from_class(klass:) || line_from_include || ''
        file_path = includer_line.split(':').first || ''

        return file_path if File.exist?(file_path)

        raise MissingFileError, "No file found at path '#{file_path}'"
      end

      private

      def line_from_class(klass:)
        class_name = klass.to_s.split(':').last # Also remove the module namespaces from the class.
        caller.find { |callee| callee.end_with?("<class:#{class_name}>'") }
      end

      def line_from_include
        caller.find { |callee| callee.end_with?("include'") }
      end
    end
  end
end
