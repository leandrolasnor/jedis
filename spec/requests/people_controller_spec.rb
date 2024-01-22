# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe PeopleController do
  path '/v1/people' do
    post('create person') do
      tags 'Person'
      consumes "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, required: true },
          taxpayer_number: { type: :string },
          cns: { type: :string },
          birthdate: { type: :string, required: true },
          email: { type: :string, required: true },
          contacts_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                number: { type: :string }
              }
            },
            required: [:number]
          },
          addresses_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                address: { type: :string },
                number: { type: :string },
                district: { type: :string },
                city: { type: :string },
                state: { type: :string },
                zip: { type: :string },
                addon: { type: :string },
                ibge: { type: :string }
              }
            },
            required: [:address, :number, :district, :city, :state, :zip, :addon, :ibge]
          }
        },
        required: [:name, :taxpayer_number, :cns, :birthdate, :email]
      }

      response(422, 'invalid params') do
        let(:params) do
          {
            person: {
              name: '',
              taxpayer_number: '',
              cns: '',
              birthdate: '',
              email: '',
              contacts_attributes: [{ number: '' }]
            }
          }
        end

        let(:expected_body) do
          {
            email: ["must be filled"],
            birthdate: ["must be filled"],
            name: ["must be filled"],
            cns: ["must be filled"],
            taxpayer_number: ["must be filled"],
            contacts_attributes: { '0' => { number: ['must be filled'] } }.symbolize_keys
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
          expect(parsed_body).to eq(expected_body)
        end
      end

      response(201, 'successful') do
        let(:name) { 'Person Name' }
        let(:taxpayer_number) { CPF.generate }
        let(:cns) { '230351998000003' }
        let(:birthdate) { '1992-02-28' }
        let(:email) { Faker::Internet.email }
        let(:contact) { build(:contact).attributes }
        let(:address) { build(:address).attributes }

        let(:params) do
          {
            person: {
              name: name,
              taxpayer_number: taxpayer_number,
              cns: cns,
              birthdate: birthdate,
              email: email,
              contacts_attributes: [contact],
              addresses_attributes: [address]
            }
          }
        end

        let(:expected_body) do
          {
            id: be_a(Integer),
            name: name,
            taxpayer_number: taxpayer_number,
            cns: cns,
            birthdate: birthdate,
            email: email,
            status: 'enabled',
            contacts: [
              {
                id: be_a(Integer),
                number: contact['number'][1..]
              }
            ],
            addresses: [
              {
                id: be_a(Integer),
                address: address['address'],
                city: address['city'],
                district: address['district'],
                number: address['number'],
                state: address['state'],
                zip: address['zip'],
                addon: address['addon'],
                ibge: address['ibge']
              }
            ]
          }
        end

        context 'on success' do
          before do |example|
            allow(Http::CreatePerson::NotifiesPersonCreated::Job).to receive(:perform_async).with(instance_of(Integer))
            submit_request(example.metadata)
          end

          it do
            expect(response).to have_http_status(:created)
            expect(parsed_body).to match(expected_body)
            expect(Http::CreatePerson::NotifiesPersonCreated::Job).
              to have_received(:perform_async).
              with(instance_of(Integer))
          end
        end
      end
    end
  end

  path '/v1/people/{id}' do
    get('show person') do
      tags 'Person'
      parameter name: :id, in: :path, type: :string, description: 'id'
      response(404, 'not found') do
        let(:id) { 0 }
        let(:expected_body) { { error: I18n.t(:not_found) } }

        run_test! do |response|
          expect(response).to have_http_status(:not_found)
          expect(parsed_body).to eq(expected_body)
        end
      end

      response(200, 'successful') do
        let(:id) { person.id }
        let(:contact) { build(:contact) }
        let(:address) { build(:address) }
        let(:person) do
          p = create(:person)
          contact.person_id = p.id
          address.person_id = p.id
          contact.save
          address.save
          p
        end

        let(:expected_body) do
          {
            id: id,
            name: person.name,
            taxpayer_number: person.taxpayer_number,
            birthdate: person.birthdate.to_date.to_s,
            email: person.email,
            cns: person.cns,
            contacts: [
              {
                id: be_a(Integer),
                number: contact.number
              }
            ],
            addresses: [
              {
                id: be_a(Integer),
                address: address.address,
                number: address.number,
                district: address.district,
                city: address.city,
                state: address.state,
                zip: address.zip,
                addon: address.addon,
                ibge: address.ibge
              }
            ]
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(parsed_body).to match(expected_body)
        end
      end
    end

    put('update person') do
      tags 'Person'
      consumes "application/json"
      parameter name: :id, in: :path, type: :string, description: 'id'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, required: false },
          status: { type: :number, required: false },
          contacts_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                number: { type: :string, required: true }
              }
            },
            required: [:number]
          },
          addresses_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                address: { type: :string, required: true },
                number: { type: :string, required: true },
                district: { type: :string, required: true },
                city: { type: :string, required: true },
                state: { type: :string, required: true },
                addon: { type: :string, required: true },
                ibge: { type: :string, required: true },
                zip: { type: :string, required: true }
              }
            },
            required: [:address, :number, :district, :city, :state, :zip, :addon, :ibge]
          }
        }
      }

      response(404, 'not found') do
        let(:id) { 0 }
        let(:expected_body) { { error: I18n.t(:not_found) } }
        let(:params) { nil }

        run_test! do |response|
          expect(response).to have_http_status(:not_found)
          expect(parsed_body).to eq(expected_body)
        end
      end

      response(422, 'invalid params') do
        let(:person) { create(:person) }
        let(:id) { person.id }
        let(:email) { '2010-02-28' }
        let(:status) { 'email@provider.com' }

        let(:params) do
          {
            email: email,
            status: status,
            contacts_attributes: [{ number: nil }],
            addresses_attributes: [{ address: '' }]
          }
        end

        let(:expected_body) do
          {
            addresses_attributes: {
              '0': {
                address: ["must be filled"]
              }
            },
            contacts_attributes: {
              '0': {
                number: ["must be filled"]
              }
            },
            email: ["Invalid Format"],
            status: ["must be one of: disabled, enabled"]
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
          expect(parsed_body).to eq(expected_body)
        end
      end

      response(200, 'successful') do
        let(:person) { create(:person) }
        let(:id) { person.id }
        let(:contact) { build(:contact).attributes }
        let(:address) { build(:address).attributes }

        let(:params) do
          {
            email: 'test@test.com',
            status: 0,
            contacts_attributes: [contact],
            addresses_attributes: [address]
          }
        end

        let(:expected_body) do
          {
            id: be_a(Integer),
            name: person.name,
            taxpayer_number: person.taxpayer_number,
            cns: person.cns,
            birthdate: person.birthdate.to_date.to_s,
            email: 'test@test.com',
            status: UpdatePerson::Models::Person.statuses.keys[0],
            contacts: [
              {
                id: be_a(Integer),
                number: contact['number']
              }
            ],
            addresses: [
              {
                id: be_a(Integer),
                address: address['address'],
                city: address['city'],
                district: address['district'],
                number: address['number'],
                state: address['state'],
                zip: address['zip'],
                addon: address['addon'],
                ibge: address['ibge']
              }
            ]
          }
        end

        context 'on success' do
          before do |example|
            allow(Http::UpdatePerson::NotifiesStatusUpdate::Job).to receive(:perform_async).with(id)
            submit_request(example.metadata)
          end

          it do
            expect(response).to have_http_status(:ok)
            expect(parsed_body).to match(expected_body)
            expect(Http::UpdatePerson::NotifiesStatusUpdate::Job).to have_received(:perform_async).with(id)
          end
        end
      end
    end
  end

  path '/v1/people/search' do
    get('search people') do
      tags 'People'
      parameter name: :query, in: :query, type: :string, description: 'query string'
      parameter name: :page, in: :query, type: :number, description: 'current page'
      parameter name: :per_page, in: :query, type: :number, description: 'count of record per page'
      response(200, 'successful') do
        let(:query) { 'test' }
        let(:page) { 2 }
        let(:per_page) { 3 }
        let(:offset) { (page - 1) * per_page }

        context 'on success' do
          before do |example|
            allow(SearchPeople::Models::Person).
              to receive(:ms_raw_search).
              with('test', limit: 3, offset: offset).
              and_return({ 'hits' => [] })
            submit_request(example.metadata)
          end

          it do
            expect(response).to have_http_status(:ok)
            expect(SearchPeople::Models::Person).
              to have_received(:ms_raw_search).
              with('test', limit: 3, offset: offset)
            expect(parsed_body).to eq([])
          end
        end
      end

      response(422, 'failure') do
        let(:query) { 'test' }
        let(:page) { nil }
        let(:per_page) { 3 }
        let(:expected_body) { { page: ["must be filled"] } }

        context 'on failure' do
          before do |example|
            allow(SearchPeople::Models::Person).to receive(:ms_raw_search)
            submit_request(example.metadata)
          end

          it do
            expect(response).to have_http_status(:unprocessable_entity)
            expect(parsed_body).to match(expected_body)
            expect(SearchPeople::Models::Person).not_to have_received(:ms_raw_search)
          end
        end
      end
    end
  end
end
