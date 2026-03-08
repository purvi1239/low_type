# frozen_string_literal: true

require 'prism'
require 'lowkey'

require_relative '../interfaces/adapter_interface'
require_relative '../proxies/return_proxy'
require_relative '../types/error_types'

module Low
  module Adapter
    # We don't use https://sinatrarb.com/extensions.html because we need to type check all Ruby methods (not just Sinatra) at a lower level.
    class SinatraAdapter < AdapterInterface
      def module(file_path:) # rubocop:disable Metrics/AbcSize
        Module.new do
          @@file_path = file_path # rubocop:disable Style/ClassVars

          # Unfortunately overriding invoke() is the best way to validate types for now. Though direct it's also very compute efficient.
          # I originally tried an after filter and it mostly worked but it only had access to Response which isn't the raw return value.
          # I suggest that Sinatra provide a hook that allows us to access the raw return value of a route before it becomes a Response.
          def invoke(&block)
            res = catch(:halt, &block)

            lowtype_validate!(value: res) if res

            res = [res] if res.is_a?(Integer) || res.is_a?(String)
            if res.is_a?(::Array) && res.first.is_a?(Integer)
              res = res.dup
              status(res.shift)
              body(res.pop)
              headers(*res)
            elsif res.respond_to? :each
              body res
            end

            nil # avoid double setting the same response tuple twice
          end

          def lowtype_validate!(value:)
            route = "#{request.request_method} #{request.path}"
            if (method_proxy = Lowkey[@@file_path][self.class.name][route]) && (proxy = method_proxy.return_proxy)
              proxy.expression.validate!(value:, proxy:)
            end
          end
        end
      end
    end
  end
end
