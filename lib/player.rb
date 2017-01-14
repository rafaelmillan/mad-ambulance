class Player
  attr_reader :lives

  def initialize
    @image_array = [Gosu::Image.new("media/amb_1.png"),
                    Gosu::Image.new("media/amb_2.png"),
                    Gosu::Image.new("media/amb_3.png")]
    @image = Gosu::Image.new("media/Ambulance_small.png")
    @x = 0
    @y = 0
    @lives = 5
    @crash = Gosu::Sample.new("media/crash.mp3")
    @font = Gosu::Font.new(20, name: "Lucida Console")

    # Score calculation
    @start_time = Time.now
    @last_time = Time.now
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @x -= 5 unless @x < 30
  end

  def turn_right
    @x += 5 unless @x > 610
  end

  def draw
    img = @image_array[Gosu::milliseconds / 100 % @image_array.size];
    img.draw_rot(@x, @y, ZOrder::Player, 0)
  end

  def crash_vehicle
    Vehicle.all.reject! do |vehicle|
      if Gosu::distance(@x, @y, vehicle.x, vehicle.y) < 60
        @lives -= 1
        Explosion.all << Explosion.new(vehicle.x, vehicle.y)
        @crash.play
        true
      else
        false
      end
    end
  end

  def draw_game_over
    @font.draw("GAME OVER", 230, 170, ZOrder::UI, 2.0, 2.0, 0xff_ffff00)
    @font.draw("Final score: #{score} seconds", 150, 230, ZOrder::UI, 1.5, 1.5, 0xff_ffff00)
  end

  def score
    @last_time = Time.now if @lives > 0
    (@last_time - @start_time).round
  end
end


