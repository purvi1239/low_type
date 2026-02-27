# frozen_string_literal: true

require_relative '../interfaces/error_interface'
require_relative '../types/error_types'

module Low
  # Originally defined in Lowtype and re-opened here to add error handling.
  class ParamProxy < ErrorInterface
    def error_type
      ArgumentTypeError
    end

    def error_message(value:)
      "Invalid argument type '#{output(value:)}' for parameter '#{@name}'. Valid types: '#{@expression.valid_types}'"
    end
  end
end
