# frozen_string_literal: true

require 'prism'
require_relative '../../lib/factories/proxy_factory'

RSpec.describe Low::ProxyFactory do
  describe '.return_proxy' do
    let(:file_path) { '/path/to/test_class.rb' }
    let(:name) { 'mock name' }
    let(:scope) { 'TestClass#test_method' }

    context 'with a valid return type' do
      let(:method_code) do
        <<~RUBY
          def test_method() -> { String }
            "hello"
          end
        RUBY
      end

      it 'creates a return proxy successfully' do
        parsed = Prism.parse(method_code)
        method_node = parsed.value.statements.body.first

        expect { described_class.return_proxy(method_node:, name:, file_path:, scope:) }.not_to raise_error
      end

      it 'returns a ReturnProxy instance' do
        parsed = Prism.parse(method_code)
        method_node = parsed.value.statements.body.first

        result = described_class.return_proxy(method_node:, name:, file_path:, scope:)

        expect(result).to be_a(Low::ReturnProxy)
      end
    end

    context 'with an unknown return type' do
      let(:method_code) do
        <<~RUBY
          def test_method() -> { UnknownType }
            "hello"
          end
        RUBY
      end

      it 'raises NameError with improved error message' do
        parsed = Prism.parse(method_code)
        method_node = parsed.value.statements.body.first

        expect { described_class.return_proxy(method_node:, name:, file_path:, scope:) }
          .to raise_error(NameError, "Unknown return type '-> { UnknownType }' for TestClass#test_method at /path/to/test_class.rb:1")
      end
    end

    context 'with no return type' do
      let(:method_code) do
        <<~RUBY
          def test_method
            "hello"
          end
        RUBY
      end

      it 'returns nil' do
        parsed = Prism.parse(method_code)
        method_node = parsed.value.statements.body.first

        result = described_class.return_proxy(method_node:, name:, file_path:, scope:)

        expect(result).to be_nil
      end
    end
  end
end
