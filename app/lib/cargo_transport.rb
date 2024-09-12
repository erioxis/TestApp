require 'net/http'
require 'json'

class CargoTransport
  DISTANCE_API_URL = 'https://api.distancematrix.ai/maps/api/distancematrix/json'.freeze
  DISTANCE_API_KEY = 'zsyQMnnVL3n85n24UpYAXaCDlcbsEkVgGqlPicMFq3psdWA2EaQrmgNq6kJVLDJz'.freeze

  def initialize(weight, length, width, height, origin, destination)
    @weight = weight
    @length = length
    @width = width
    @height = height
    @origin = origin
    @destination = destination
  end

  def calculate
    distance = fetch_distance
    price = calculate_price(distance)
    {
      weight: @weight,
      length: @length,
      width: @width,
      height: @height,
      distance: distance,
      price: price
    }
  end

  private

  def fetch_distance
    uri = URI(DISTANCE_API_URL)
    params = {
      origins: @origin,
      destinations: @destination,
      key: DISTANCE_API_KEY
    }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    
    if data['status'] == 'OK'
      distance_matrix = data['rows'].first['elements'].first
      distance_matrix['distance']['value'] / 1000.0
    else
      raise "Error fetching distance: #{data['status']}"
    end
  end

  def calculate_price(distance)
    volume = @length * @width * @height / 1_000_000.0

    if volume <= 1
      price_per_km = 1
    elsif volume > 1 && @weight <= 10
      price_per_km = 2
    else
      price_per_km = 3
    end

    price_per_km * distance
  end
end
