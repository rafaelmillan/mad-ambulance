class GameWindow < Gosu::Window
  def initialize
    # Window
    @width = 640
    @height = 480
    super @width, @height
    self.caption = "Mad Ambulance"
    @background_image = Gosu::Image.new("media/street.png", :tileable => true)
    @bg_y = 0
    @bg_x = 0

    # Player and spawning
    @player = Player.new
    @player.warp(325, 400)

    # Media
    @soundtrack = Gosu::Song.new("media/music.wav")
    @font = Gosu::Font.new(20, name: "Lucida Console")
  end

  def update
    @soundtrack.play(true)

    @bg_y += SPEED

    if Gosu::button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if Gosu::button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight then
      @player.turn_right
    end

    @player.crash_vehicle

    if rand(100) < SPAWNING_FREQUENCY then
      Vehicle.new
    end

    @player.score
  end

  def draw
    @player.draw

    Vehicle.all.each do |vehicle|
      vehicle.draw
    end

    Explosion.all.each do |explosion|
      explosion.draw
      Explosion.all.delete(explosion) if explosion.done?
    end

    @local_y = @bg_y % - @background_image.height
    @background_image.draw(@bg_x, @local_y, ZOrder::Background)

    if @local_y < 0
      @background_image.draw(@bg_x, @local_y + @background_image.height, ZOrder::Background)
    end

    @player.draw_game_over if @player.lives < 1

    @font.draw("Score: #{@player.score} sec", 50, 400, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @font.draw("Lives remaining: #{@player.lives < 1 ? "" : "* " * @player.lives}", 50, 430, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

module ZOrder
  Background, Vehicles, Player, UI = *0..3
end
