# frozen_string_literal: true

require 'spec_helper'

describe '#539 post params given as array' do
  let(:app) do
    Class.new(Grape::API) do
      namespace :issue_539 do
        class Element < Grape::Entity
          expose :id
          expose :description
          expose :role
        end

        class ArrayOfElements < Grape::Entity
          expose :elements,
                 documentation: {
                   type: Element, is_array: true, param_type: 'body', required: true
                 }
        end

        desc 'create account',
             params: ArrayOfElements.documentation
        post do
          present params
        end
      end

      add_swagger_documentation format: :json
    end
  end

  subject do
    get '/swagger_doc'
    JSON.parse(last_response.body)
  end

  let(:parameters) { subject['paths']['/issue_539']['post']['parameters'] }
  let(:definitions) { subject['definitions'] }

  specify do
    expect(parameters).to match(
      [
        {
          'name' => 'postIssue539',
          'required' => true,
          'in' => 'body',
          'schema' => { '$ref' => '#/definitions/postIssue539' }
        }
      ]
    )
  end

  specify do
    expect(definitions).to include(
      'postIssue539' => {
        'description' => 'create account',
        'type' => 'object',
        'properties' => {
          'elements' => {
            'type' => 'array', 'items' => { '$ref' => '#/definitions/Element' }
          }
        },
        'required' => ['elements']
      }
    )
  end

  specify do
    expect(definitions).to include(
      'Element' => {
        'type' => 'object',
        'properties' => {
          'id' => { 'type' => 'string' },
          'description' => { 'type' => 'string' },
          'role' => { 'type' => 'string' }
        }
      }
    )
  end
end
