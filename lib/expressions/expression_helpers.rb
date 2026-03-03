# frozen_string_literal: true

require_relative 'type_expression'
require_relative 'value_expression'
require_relative '../proxies/local_proxy'

module Low
  module ExpressionHelpers
    def type(type_expression)
      value = type_expression.default_value

      last_caller = caller_locations(1, 1).first
      file_path = last_caller.path
      start_line = last_caller.lineno
      proxy = LocalProxy.new(type_expression:, name: self, file_path:, start_line:, scope: 'local type')

      type_expression.validate!(value:, proxy:)

      return value.value if value.is_a?(ValueExpression)

      value
    rescue NoMethodError
      raise ConfigError, "Invalid type expression. Did you add 'using LowType::Syntax'?"
    end
    alias low_type type

    def value(type)
      TypeExpression.new(default_value: ValueExpression.new(value: type))
    end
    alias low_value value
  end
end
