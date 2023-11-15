# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe PeopleController do
  path '/v1/people' do
    post('create person') do
      tags 'People'
      consumes "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, required: true },
          taxpayer_number: { type: :integer },
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

        run_test! do |response|
          expect(response).to have_http_status(:created)
          expect(parsed_body).to match(expected_body)
        end
      end
    end
  end
end
