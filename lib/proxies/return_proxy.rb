# frozen_string_literal: true

require_relative '../interfaces/error_interface'
require_relative '../types/error_types'

module Low
  class ReturnProxy < ErrorInterface
    def error_type
      ReturnTypeError
    end

    def error_message(value:)
      "Invalid return type '#{output(value:)}' for method '#{@name}'. Valid types: '#{@type_expression.valid_types}'"
    end
  end
end
