require_relative 'board'
require_relative 'player'

class Game
  attr_accessor :board

  def initialize
    @board = ChessBoard.new.board
  end
end
