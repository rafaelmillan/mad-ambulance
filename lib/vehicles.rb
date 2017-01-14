class Vehicle
  attr_accessor :x, :y

  def initialize
    @vehicles = [Gosu::Image.new("media/Mini_truck_small.png"),
                  Gosu::Image.new("media/Mini_van_small.png"),
                  Gosu::Image.new("media/Police_small.png"),
                  Gosu::Image.new("media/taxi_small.png")]
    @img = @vehicles.sample
    @goes_north = [true, false].sample
    @x = @goes_north ? [350, 420, 490, 560].sample : [70, 140, 210, 280].sample
    @y = -150
    @@vehicles << self
  end

  @@vehicles = []

  def self.all
    @@vehicles
  end

  def draw
    if next_car_too_close? # Stops the vehicle if the next one is too close
      @img.draw_rot(@x, @y, ZOrder::Vehicles, 0)
    elsif @goes_north
      @y = @y + SPEED * 0.7
      @img.draw_rot(@x, @y, ZOrder::Vehicles, 0)
    else
      @y = @y + SPEED * 1.15
      @img.draw_rot(@x, @y, ZOrder::Vehicles, 180)
    end
  end

  def next_car_too_close?
    cars_in_lane = @@vehicles.select { |vehicle| vehicle.x == @x && vehicle != self }
    cars_in_lane.sort_by! { |vehicle| vehicle.y }
    next_car = cars_in_lane.find { |vehicle| vehicle.y > @y }
    if next_car.nil?
      return false
    else
      return next_car.y < 300
    end
  end
end
