require_relative 'board'
require_relative 'player'

class Game
  attr_accessor :board

  def initialize
    @board = ChessBoard.new.board
    @white = Player.new('white')
    @black = Player.new('black')
  end

  def display_board
    # row 8
    puts "\n\t| #{@board[56].state} | #{@board[57].state} | #{@board[58].state} | #{@board[59].state} | #{@board[60].state} | #{@board[61].state} | #{@board[62].state} | #{@board[63].state} |"
    puts "\t---------------------------------"

    # row 7
    puts "\t| #{@board[48].state} | #{@board[49].state} | #{@board[50].state} | #{@board[51].state} | #{@board[52].state} | #{@board[53].state} | #{@board[54].state} | #{@board[55].state} |"
    puts "\t---------------------------------"

    # row 6
    puts "\t| #{@board[40].state} | #{@board[41].state} | #{@board[42].state} | #{@board[43].state} | #{@board[44].state} | #{@board[45].state} | #{@board[46].state} | #{@board[47].state} |"
    puts "\t---------------------------------"

    # row 5
    puts "\t| #{@board[32].state} | #{@board[33].state} | #{@board[34].state} | #{@board[35].state} | #{@board[36].state} | #{@board[37].state} | #{@board[38].state} | #{@board[39].state} |"
    puts "\t---------------------------------"

    # row 4
    puts "\t| #{@board[24].state} | #{@board[25].state} | #{@board[26].state} | #{@board[27].state} | #{@board[28].state} | #{@board[29].state} | #{@board[30].state} | #{@board[31].state} |"
    puts "\t---------------------------------"

    # row 3
    puts "\t| #{@board[16].state} | #{@board[17].state} | #{@board[18].state} | #{@board[19].state} | #{@board[20].state} | #{@board[21].state} | #{@board[22].state} | #{@board[23].state} |"
    puts "\t---------------------------------"

    # row 2
    puts "\t| #{@board[8].state} | #{@board[9].state} | #{@board[10].state} | #{@board[11].state} | #{@board[12].state} | #{@board[13].state} | #{@board[14].state} | #{@board[15].state} |"
    puts "\t---------------------------------"

    # row 1
    puts "\t| #{@board[0].state} | #{@board[1].state} | #{@board[2].state} | #{@board[3].state} | #{@board[4].state} | #{@board[5].state} | #{@board[6].state} | #{@board[7].state} |"
    puts "\n"
  end
end
