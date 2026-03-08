# frozen_string_literal: true

require 'lowkey'

require_relative '../interfaces/error_handling'
require_relative '../types/error_types'

module ::Lowkey
  class ParamProxy
    include ::Low::ErrorHandling

    def error_type
      ::Low::ArgumentTypeError
    end

    def error_message(value:)
      "Invalid argument type '#{output(value:)}' for parameter '#{@name}'. Valid types: '#{@expression.valid_types}'"
    end
  end
end
