require "test_helper"

describe RentalsController do

  before do
    @customer = customers(:one)
    @movie = movies(:four)
  end

  RENTAL_PARAMS = %w(movie_id customer_id).sort!

  def check_response(expected_type:, expected_status: :success)
    must_respond_with expected_status
    expect(response.header['Content-Type']).must_include 'json'

    body = JSON.parse(response.body)
    expect(body).must_be_kind_of expected_type
    return body
  end


  # post 'rentals/check-out', to: 'rentals#create', as: 'checkout_rental'
  #
  # post 'rentals/check-in', to: 'rentals#update', as: 'checkin_rental'

  let(:create_rental_params){
    {
      customer_id: @customer.id,
      movie_id: @movie.id
    }
  }

  describe 'create' do

    it 'creates a new rental given valid data' do
      expect {
        post checkout_rental_path, params: create_rental_params
      }.must_change 'Rental.count', 1

      body = check_response(expected_type: Hash)

      expect(body.keys).must_include "id"
      expect(body.keys).must_include "checked_out"
      expect(Rental.last.id).must_equal body["id"]
    end

    # it 'returns an error for invalid movie data' do
    #
    #   movie_params = { name: nil, inventory: -1 }
    #
    #   expect{
    #     post movies_path, params: movie_params
    #   }.wont_change 'Movie.count'
    #
    #   body = check_response(expected_type: Hash, expected_status: :bad_request)
    #   expect(body).must_include "errors"
    #   expect(body["errors"]).must_include "title"
    #   expect(body["errors"]).must_include "inventory"
    #   expect(Movie.last.id).wont_equal body["id"]
    # end
  end



end
