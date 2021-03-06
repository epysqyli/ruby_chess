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

  def detect_square(x, y)
    @board.detect { |s| [s.x, s.y] == [x, y] }
  end

  def detect_color(x, y)
    detect_square(x, y).color
  end

  def detect_piece(x, y)
    pos = detect_square(x, y)
    if pos.state == ChessBoard.black_pieces[:king] || pos.state == ChessBoard.white_pieces[:king]
      'king'
    elsif pos.state == ChessBoard.black_pieces[:queen] || pos.state == ChessBoard.white_pieces[:queen]
      'queen'
    elsif pos.state == ChessBoard.black_pieces[:bishop] || pos.state == ChessBoard.white_pieces[:bishop]
      'bishop'
    elsif pos.state == ChessBoard.black_pieces[:knight] || pos.state == ChessBoard.white_pieces[:knight]
      'knight'
    elsif pos.state == ChessBoard.black_pieces[:rook] || pos.state == ChessBoard.white_pieces[:rook]
      'rook'
    elsif pos.state == ChessBoard.black_pieces[:pawn] || pos.state == ChessBoard.white_pieces[:pawn]
      'pawn'
    else
      ' '
    end
  end

  def detect_path(x1, y1, x2, y2)
    path = []

    #single axis movements
    if x2 > x1 || y2 > y1
      if x1 == x2 && y1 != y2
        until y1 == y2
          y1 += 1
          path << detect_square(x1, y1)
        end
      elsif x1 != x2 && y1 == y2
        until x1 == x2
          x1 += 1
          path << detect_square(x1, y1)
        end
      end
    elsif x2 < x1 || y2 < y1
      if x1 == x2 && y1 != y2
        until y1 == y2
          y1 -= 1
          path << detect_square(x1, y1)
        end
      elsif x1 != x2 && y1 == y2
        until x1 == x2
          x1 -= 1
          path << detect_square(x1, y1)
        end
      end
    end

    #both axis movements
    if x1 < x2 && y1 < y2
      until x1 == x2 && y1 == y2
        x1 += 1
        y1 += 1
        path << detect_square(x1, y1)
      end
    elsif x1 > x2 && y1 > y2
      until x1 == x2 && y1 == y2
        x1 -= 1
        y1 -= 1
        path << detect_square(x1, y1)
      end
    elsif x1 < x2 && y1 > y2
      until x1 == x2 && y1 == y2
        x1 += 1
        y1 -= 1
        path << detect_square(x1, y1)
      end
    elsif x1 > x2 && y1 < y2
      until x1 == x2 && y1 == y2
        x1 -= 1
        y1 += 1
        path << detect_square(x1, y1)
      end
    end

    path.pop
    return path
  end

  def free_path?(x1, y1, x2, y2)
    if detect_path(x1, y1, x2, y2).all? { |square| square.state == ' ' }
      return true
    else
      return false
    end
  end

  def same_color?(x1, y1, x2, y2)
    start_color = detect_color(x1, y1)
    finish_color = detect_color(x2, y2)
    start_color == finish_color ? true : false
  end

  def check_pawn_move(x1, y1, _x2, y2)
    if detect_piece(x1, y1) == 'pawn' && detect_color(x1, y1) == 'white'
      if y2 - y1 == 1
        'allowed'
      elsif y2 - y1 == 2 && y1 == 2
        'allowed'
      else
        'Invalid move for the type'
      end
    elsif detect_piece(x1, y1) == 'pawn' && detect_color(x1, y1) == 'black'
      if y1 - y2 == 1
        'allowed'
      elsif y1 - y2 == 2 && y1 == 7
        'allowed'
      else
        'Invalid move for the type'
      end
    end
  end

  def check_rook_move(x1, y1, x2, y2)
    if detect_piece(x1, y1) == 'rook'
      if x1 == x2
        'allowed'
      elsif y1 == y2
        'allowed'
      else
        'Invalid move for the type'
      end
    end
  end

  def check_knight_move(x1, y1, x2, y2)
    if detect_piece(x1, y1) == 'knight'
      if (x2 - x1) == 2 && (y2 - y1) == 1
        'allowed'
      elsif (x2 - x1) == 2 && (y2 - y1) == -1
        'allowed'
      elsif (x2 - x1) == -2 && (y2 - y1) == 1
        'allowed'
      elsif (x2 - x1) == -2 && (y2 - y1) == -1
        'allowed'
      elsif (x2 - x1) == 1 && (y2 - y1) == 2
        'allowed'
      elsif (x2 - x1) == -1 && (y2 - y1) == 2
        'allowed'
      elsif (x2 - x1) == 1 && (y2 - y1) == -2
        'allowed'
      elsif (x2 - x1) == -1 && (y2 - y1) == -2
        'allowed'
      else
        'Invalid move for the type'
      end
    end
  end

  def check_bishop_move(x1, y1, x2, y2)
    if detect_piece(x1, y1) == 'bishop'
      if (x2 - x1).abs == (y2 - y1).abs
        'allowed'
      else
        'Invalid move for the type'
      end
    end
  end

  def check_queen_move(x1, y1, x2, y2)
    if detect_piece(x1, y1) == 'queen'
      if (x2 - x1).abs == (y2 - y1).abs
        'allowed'
      elsif x1 == x2
        'allowed'
      elsif y1 == y2
        'allowed'
      else
        'Invalid move for the type'
      end
    end
  end

  def check_king_move(x1, y1, x2, y2)
    if detect_piece(x1, y1) == 'king'
      if (x2 - x1).abs == (y2 - y1).abs && (x2 - x1).abs == 1
        'allowed'
      elsif x1 == x2 && (y2 - y1).abs == 1
        'allowed'
      elsif y1 == y2 && (x2 - x1).abs == 1
        'allowed'
      else
        'Invalid move for the type'
      end
    end
  end

  def check_move(x1, y1, x2, y2)
    if check_pawn_move(x1, y1, x2, y2) == 'allowed'
      type = 'pawn'
      return 'allowed'
    elsif check_rook_move(x1, y1, x2, y2) == 'allowed'
      type = 'rook'
      return 'allowed'
    elsif check_knight_move(x1, y1, x2, y2) == 'allowed'
      type = 'knight'
      return 'allowed'
    elsif check_bishop_move(x1, y1, x2, y2) == 'allowed'
      type = 'bishop'
      return 'allowed'
    elsif check_queen_move(x1, y1, x2, y2) == 'allowed'
      type = 'queen'
      return 'allowed'
    elsif check_king_move(x1, y1, x2, y2) == 'allowed'
      type = 'king'
      return 'allowed'
    else
      return 'not allowed'
    end
  end

  def update_state(x1, y1, x2, y2)
    start = detect_square(x1, y1)
    finish = detect_square(x2, y2)

    # refactor in #update_square ?
    empty = ' '
    piece = start.state
    start.state = empty
    finish.state = piece
  end

  def make_move(x1, y1, x2, y2)
    if check_move(x1, y1, x2, y2) == 'allowed' && detect_piece(x1, y1) != 'knight'
      update_state(x1, y1, x2, y2) if free_path?(x1, y1, x2, y2) && !same_color?(x1, y1, x2, y2)
      message = 'move made'
    elsif check_move(x1, y1, x2, y2) == 'allowed' && detect_piece(x1, y1) == 'knight'
      update_state(x1, y1, x2, y2) if !same_color?(x1, y1, x2, y2)
      message = 'move made'
    else
      message = "move is not allowed"
    end
    puts message
  end
end
