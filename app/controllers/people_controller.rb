# frozen_string_literal: true

class PeopleController < BaseController
  def show
    status, content, serializer = Http::ShowPerson::Service.(show_params)
    render json: content, status: status, serializer: serializer
  end

  def create
    status, content, serializer = Http::CreatePerson::Service.(create_params)
    render json: content, status: status, serializer: serializer
  end

  def update
    status, content, serializer = Http::UpdatePerson::Service.(update_params)
    render json: content, status: status, serializer: serializer
  end

  def search
    status, content = Http::SearchPeople::Service.(search_params)
    render json: content, status: status
  end

  private

  def create_params
    params.require(:person).permit(
      :name,
      :status,
      :taxpayer_number,
      :birthdate,
      :cns,
      :email,
      addresses_attributes: [
        :address,
        :number,
        :district,
        :city,
        :state,
        :zip,
        :addon,
        :ibge
      ],
      contacts_attributes: [:number]
    )
  end

  def search_params
    params.permit(:query, :page, :per_page)
  end

  def update_params
    params.permit(
      :id,
      :status,
      :email,
      addresses_attributes: [
        :id,
        :address,
        :number,
        :district,
        :city,
        :state,
        :zip,
        :addon,
        :ibge,
        :_destroy
      ],
      contacts_attributes: [:id, :number, :_destroy]
    )
  end

  def show_params
    params.permit(:id)
  end
end
