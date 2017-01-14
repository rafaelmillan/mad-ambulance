class Explosion
  def initialize(x, y)
    @x = x
    @y = y
    @animation = Gosu::Image::load_tiles("media/explosion.png", 64, 64)
    @start_time = Gosu::milliseconds
    @tile_refresh_rate = 100
    @@explosions << self
  end

  @@explosions = []

  def self.all
    @@explosions
  end

  def draw
    index_to_draw = (Gosu::milliseconds - @start_time) / @tile_refresh_rate
    @y += SPEED / 3
    @animation[index_to_draw].draw_rot(@x, @y, ZOrder::UI, 0) if index_to_draw < @animation.size
  end

  def done? # Checks if all the tiles were drawn once
    Gosu::milliseconds > @start_time + (@tile_refresh_rate * @animation.size)
  end
end
