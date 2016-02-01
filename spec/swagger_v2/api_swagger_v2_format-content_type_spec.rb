require 'spec_helper'

describe 'format, content_type' do
  include_context "the api entities"

  before :all do
    module TheApi
      class ProducesApi < Grape::API
        format :json

        desc 'This uses formats for produces',
          failure: [{code: 400, model: Entities::ApiError}],
          formats: [:xml, :binary, "application/vdns"],
          entity: Entities::UseResponse
        get '/use_format' do
          { "declared_params" => declared(params) }
        end

        desc 'This uses content_types for produces',
          failure: [{code: 400, model: Entities::ApiError}],
          content_types: [:xml, :binary, "application/vdns"],
          entity: Entities::UseResponse
        get '/use_content_type' do
          { "declared_params" => declared(params) }
        end

        add_swagger_documentation
      end
    end
  end

  def app
    TheApi::ProducesApi
  end

  subject do
    get '/swagger_doc/use_format'
    JSON.parse(last_response.body)
  end

  specify do
    expect(subject['paths']['/use_produces']['get']).to include('produces')
    expect(subject['paths']['/use_produces']['get']['produces']).to eql([
      'application/xml',
      'application/octet-stream',
      'application/vdns'
      ])
  end

  subject do
    get '/swagger_doc/use_content_type'
    JSON.parse(last_response.body)
  end

  specify do
    expect(subject['paths']['/use_produces']['get']).to include('produces')
    expect(subject['paths']['/use_produces']['get']['produces']).to eql([
      'application/xml',
      'application/octet-stream',
      'application/vdns'
      ])
  end
end
