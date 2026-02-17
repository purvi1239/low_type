# frozen_string_literal: true

module Low
  class MethodProxy
    attr_reader :file_path, :start_line, :scope, :name, :param_proxies, :return_proxy

    # TODO: Refactor file path, start line and scope into "meta scope" model.
    def initialize(file_path:, start_line:, scope:, name:, param_proxies: [], return_proxy: nil) # rubocop:disable Metrics/ParameterLists
      @file_path = file_path
      @start_line = start_line
      @scope = scope

      @name = name
      @param_proxies = param_proxies
      @return_proxy = return_proxy
    end
  end
end
