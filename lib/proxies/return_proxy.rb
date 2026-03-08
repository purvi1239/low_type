# frozen_string_literal: true

require 'lowkey'

require_relative '../interfaces/error_handling'
require_relative '../types/error_types'

module ::Lowkey
  class ReturnProxy
    include ::Low::ErrorHandling

    def error_type
      ::Low::ReturnTypeError
    end

    def error_message(value:)
      "Invalid return type '#{output(value:)}' for method '#{@name}'. Valid types: '#{@expression.valid_types}'"
    end
  end
end
