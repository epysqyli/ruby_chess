require_relative 'board.rb'

class Player
  attr_reader :color

  def initialize(color)
    @color = color
  end
end