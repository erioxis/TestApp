class CargoRequestsController < ApplicationController
  def new
    @cargo_request = CargoRequest.new
  end

  def create
    @cargo_request = CargoRequest.new(cargo_request_params)
    distance = calculate_distance(@cargo_request.origin, @cargo_request.destination)
    price = calculate_price(@cargo_request.weight, @cargo_request.length, @cargo_request.width, @cargo_request.height, distance)
    
    @cargo_request.distance = distance
    @cargo_request.price = price
    
    if @cargo_request.save
      redirect_to @cargo_request
    else
      render :new
    end
  end

  def show
    @cargo_request = CargoRequest.find(params[:id])
  end

  private

  def cargo_request_params
    params.require(:cargo_request).permit(:first_name, :last_name, :middle_name, :phone, :email, :weight, :length, :width, :height, :origin, :destination)
  end

  def calculate_distance(origin, destination)
    uri = URI(CargoTransport::DISTANCE_API_URL)
    params = {
      origins: origin,
      destinations: destination,
      key: CargoTransport::DISTANCE_API_KEY
    }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    if data['status'] == 'OK'
      distance_matrix = data['rows'].first['elements'].first
      distance_matrix['distance']['value'] / 1000.0 # расстояние в километрах
    else
      raise "Error fetching distance: #{data['status']}"
    end
  end

  def calculate_price(weight, length, width, height, distance)
    volume = length * width * height / 1_000_000.0 # объем в кубометрах

    if volume <= 1
      price_per_km = 1
    elsif volume > 1 && weight <= 10
      price_per_km = 2
    else
      price_per_km = 3
    end

    price_per_km * distance
  end
end
