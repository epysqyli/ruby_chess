# black and white unicodes used in opposite way due to final display qualities
# puts black_pieces[:king].encode. Maybe add encode function later

class Square
  attr_reader :x, :y
  attr_accessor :state

  def initialize(x, y, state = ' ')
    @x = x
    @y = y
    @state = state
    @color = color
  end
end

class ChessBoard
  attr_accessor :board

  def initialize
    @board = []
    create_board
  end

  def self.black_pieces
    black_pieces = {
      king: "\u2654",
      queen: "\u2655",
      rook: "\u2656",
      bishop: "\u2657",
      knight: "\u2658",
      pawn: "\u2659"
    }
  end

  def self.white_pieces
    white_pieces = {
      king: "\u265A",
      queen: "\u265B",
      rook: "\u265C",
      bishop: "\u265D",
      knight: "\u265E",
      pawn: "\u265F"
    }
  end

  def create_board
    # white pieces first row
    @board << Square.new(1, 1, state = ChessBoard.white_pieces[:rook], color = 'white')
    @board << Square.new(2, 1, state = ChessBoard.white_pieces[:knight], color = 'white')
    @board << Square.new(3, 1, state = ChessBoard.white_pieces[:bishop] color = 'white')
    @board << Square.new(4, 1, state = ChessBoard.white_pieces[:queen], color = 'white')
    @board << Square.new(5, 1, state = ChessBoard.white_pieces[:king], color = 'white')
    @board << Square.new(6, 1, state = ChessBoard.white_pieces[:bishop], color = 'white')
    @board << Square.new(7, 1, state = ChessBoard.white_pieces[:knight], color = 'white')
    @board << Square.new(8, 1, state = ChessBoard.white_pieces[:rook], color = 'white')

    # white pawns creation
    x = 1
    y = 2
    while x < 9
      @board << Square.new(x, y, state = ChessBoard.white_pieces[:pawn], color = 'white')
      x += 1
    end

    # empty squares creation
    x = 1
    y = 3
    while y < 7
      while x < 9
        @board << Square.new(x, y)
        x += 1
      end
      x = 1
      y += 1
    end

    # black pawns creation
    x = 1
    y = 7
    while x < 9
      @board << Square.new(x, y, state = ChessBoard.black_pieces[:pawn], color = 'black')
      x += 1
    end

    # black pieces first row
    @board << Square.new(1, 8, state = ChessBoard.black_pieces[:rook], color = 'black')
    @board << Square.new(2, 8, state = ChessBoard.black_pieces[:knight], color = 'black')
    @board << Square.new(3, 8, state = ChessBoard.black_pieces[:bishop], color = 'black')
    @board << Square.new(4, 8, state = ChessBoard.black_pieces[:queen], color = 'black')
    @board << Square.new(5, 8, state = ChessBoard.black_pieces[:king], color = 'black')
    @board << Square.new(6, 8, state = ChessBoard.black_pieces[:bishop], color = 'black')
    @board << Square.new(7, 8, state = ChessBoard.black_pieces[:knight], color = 'black')
    @board << Square.new(8, 8, state = ChessBoard.black_pieces[:rook], color = 'black')
  end

end
