# frozen_string_literal: true
module GrapeSwagger
  module Errors
    class MarkdownDependencyMissingError < StandardError
      def initialize(missing_gem)
        super("Missing required dependency: #{missing_gem}")
      end
    end

    class UnregisteredParser < StandardError; end
    class SwaggerSpec < StandardError; end
  end
end
