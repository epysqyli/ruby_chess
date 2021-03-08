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

    # single axis movements
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

    # both axis movements
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
    path
  end

  def free_path?(x1, y1, x2, y2)
    path = detect_path(x1, y1, x2, y2)
    path.pop
    if path.all? { |square| square.state == ' ' }
      true
    else
      false
    end
  end

  def same_color?(x1, y1, x2, y2)
    start_color = detect_color(x1, y1)
    finish_color = detect_color(x2, y2)
    start_color == finish_color
  end

  def detect_white_king
    @board.detect { |s| s.state == ChessBoard.white_pieces[:king] }
  end

  def detect_black_king
    @board.detect { |s| s.state == ChessBoard.black_pieces[:king] }
  end

  def check_pawn_move(x1, y1, x2, y2)
    # white pawns logic
    if detect_piece(x1, y1) == 'pawn' && detect_color(x1, y1) == 'white'
      if detect_piece(x2, y2) == ' '
        if y2 - y1 == 1
          'allowed'
        elsif y2 - y1 == 2 && y1 == 2 && x2 == x1
          'allowed'
        else
          'Invalid move for the type'
        end
      # pawn eating logic
      elsif detect_color(x2, y2) == 'black'
        if (x2 - x1).abs == (y2 - y1).abs
          if (y2 - y1).abs == 1
            'allowed'
          else
            'Invalid move for the type'
          end
        end
      end

    # black pawns logic
    elsif detect_piece(x1, y1) == 'pawn' && detect_color(x1, y1) == 'black'
      if detect_piece(x2, y2) == ' '
        if y1 - y2 == 1
          'allowed'
        elsif y1 - y2 == 2 && y1 == 7 && x1 == x2
          'allowed'
        else
          'Invalid move for the type'
        end
      # pawn eating logic
      elsif detect_color(x2, y2) == 'white'
        if (x2 - x1).abs == (y2 - y1).abs
          if (y2 - y1).abs == 1
            'allowed'
          else
            'Invalid move for the type'
          end
        end
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
      'allowed'
    elsif check_rook_move(x1, y1, x2, y2) == 'allowed'
      type = 'rook'
      'allowed'
    elsif check_knight_move(x1, y1, x2, y2) == 'allowed'
      type = 'knight'
      'allowed'
    elsif check_bishop_move(x1, y1, x2, y2) == 'allowed'
      type = 'bishop'
      'allowed'
    elsif check_queen_move(x1, y1, x2, y2) == 'allowed'
      type = 'queen'
      'allowed'
    elsif check_king_move(x1, y1, x2, y2) == 'allowed'
      type = 'king'
      'allowed'
    else
      'not allowed'
    end
  end

  def update_square(x1, y1, x2, y2)
    start = detect_square(x1, y1)
    finish = detect_square(x2, y2)

    empty = ' '
    state = start.state
    color = start.color
    start.state = empty
    start.color = empty
    finish.state = state
    finish.color = color
  end

  def make_move(x1, y1, x2, y2)
    if check_move(x1, y1, x2, y2) == 'allowed' && detect_piece(x1, y1) != 'knight'
      update_square(x1, y1, x2, y2) if free_path?(x1, y1, x2, y2) && !same_color?(x1, y1, x2, y2)
    elsif check_move(x1, y1, x2, y2) == 'allowed' && detect_piece(x1, y1) == 'knight'
      update_square(x1, y1, x2, y2) unless same_color?(x1, y1, x2, y2)
    else
      puts 'invalid move'
    end
  end

  def pawn_check(king)
    x = king.x
    y = king.y
    condition = 'nope'

    if king.color == 'white'
      moves = [[x + 1, y + 1], [x - 1, y + 1]]
      moves.select! { |move| move[0] < 9 && move[1] < 9 }
      moves.select! { |move| move[0] > 0 && move[1] > 0 }
      until condition == 'check' || moves.empty?
        move = moves.shift
        x = move[0]
        y = move[1]
        condition = 'check' if detect_piece(x, y) == 'pawn' && detect_color(x, y) == 'black'
      end

    elsif king.color == 'black'
      moves = [[x + 1, y - 1], [x - 1, y - 1]]
      moves.select! { |move| move[0] < 9 && move[1] < 9 }
      moves.select! { |move| move[0] > 0 && move[1] > 0 }
      until condition == 'check' || moves.empty?
        move = moves.shift
        x = move[0]
        y = move[1]
        condition = 'check' if detect_piece(x, y) == 'pawn' && detect_color(x, y) == 'white'
      end
    end
    return condition
  end

  def knight_check(king)
    x = king.x
    y = king.y
    moves = [[x + 2, y + 1], [x + 2, y - 1], [x - 2, y + 1], [x - 2, y - 1], [x + 1, y - 2], [x - 1, y + 2], [x + 1, y + 2], [x - 1, y - 2]]
    moves.select! { |move| move[0] < 9 && move[1] < 9 }
    moves.select! { |move| move[0] > 0 && move[1] > 0 }
    condition = 'nope'

    if king.color == 'black'
      until condition == 'check' || moves.empty?
        move = moves.shift
        x = move[0]
        y = move[1]
        condition = 'check' if detect_piece(x, y) == 'knight' && detect_color(x, y) == 'white'
      end

    elsif king.color == 'white'
      until condition == 'check' || moves.empty?
        move = moves.shift
        x = move[0]
        y = move[1]
        condition = 'check' if detect_piece(x, y) == 'knight' && detect_color(x, y) == 'black'
      end
    end

    condition
  end

  def rook_check(king)
    # left path
    left_path = []
    detect_path(king.x, king.y, 1, king.y).each { |s| left_path << s }

    # right path
    right_path = []
    detect_path(king.x, king.y, 8, king.y).each { |s| right_path << s }

    # up path
    up_path = []
    detect_path(king.x, king.y, king.x, 8).each { |s| up_path << s }

    # down path
    down_path = []
    detect_path(king.x, king.y, king.x, 1).each { |s| down_path << s }

    condition = 'nope'

    if king.color == 'white'
      # left path
      rook = left_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'black'
      end
      unless rook.nil?
        return condition = 'check' if free_path?(king.x, king.y, rook.x, rook.y)
      end

      # right_path
      rook = right_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'black'
      end
      unless rook.nil?
        return condition = 'check' if free_path?(king.x, king.y, rook.x, rook.y)
      end

      # up path
      rook = up_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'black'
      end
      unless rook.nil?
        return condition = 'check' if free_path?(king.x, king.y, rook.x, rook.y)
      end

      # down path
      rook = down_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'black'
      end
      unless rook.nil?
        return condition = 'check' if free_path?(king.x, king.y, rook.x, rook.y)
      end

    elsif king.color == 'black'

      # left path
      rook = left_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'white'
      end
      unless rook.nil?
        return condition = 'check' if free_path?(king.x, king.y, rook.x, rook.y)
      end

      # right_path
      rook = right_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'white'
      end
      unless rook.nil?
        return condition = 'check' if free_path?(king.x, king.y, rook.x, rook.y)
      end

      # up path
      rook = up_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'white'
      end
      unless rook.nil?
        return condition = 'check' if free_path?(king.x, king.y, rook.x, rook.y)
      end

      # down path
      rook = down_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'white'
      end
      unless rook.nil?
        return condition = 'check' if free_path?(king.x, king.y, rook.x, rook.y)
      end

    end
    condition
  end

  def bishop_check(king)
    # nw path
    nw_path = []
    x2 = king.x
    y2 = king.y
    until x2 == 8 || y2 == 8
      x2 += 1
      y2 += 1
    end
    detect_path(king.x, king.y, x2, y2).each { |s| nw_path << s }

    # ne path
    ne_path = []
    x2 = king.x
    y2 = king.y
    until x2 == 1 || y2 == 8
      x2 -= 1
      y2 += 1
    end
    detect_path(king.x, king.y, x2, y2).each { |s| ne_path << s }

    # sw path
    sw_path = []
    x2 = king.x
    y2 = king.y
    until x2 == 1 || y2 == 1
      x2 -= 1
      y2 -= 1
    end
    detect_path(king.x, king.y, x2, y2).each { |s| sw_path << s }

    # se path
    se_path = []
    x2 = king.x
    y2 = king.y
    until x2 == 8 || y2 == 1
      x2 += 1
      y2 -= 1
    end
    detect_path(king.x, king.y, x2, y2).each { |s| se_path << s }

    condition = 'nope'

    if king.color == 'white'
      # nw path
      bishop = nw_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'black'
      end
      unless bishop.nil?
        return condition = 'check' if free_path?(king.x, king.y, bishop.x, bishop.y)
      end

      # ne path
      bishop = ne_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'black'
      end
      unless bishop.nil?
        return condition = 'check' if free_path?(king.x, king.y, bishop.x, bishop.y)
      end

      # se path
      bishop = se_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'black'
      end
      unless bishop.nil?
        return condition = 'check' if free_path?(king.x, king.y, bishop.x, bishop.y)
      end

      # sw path
      bishop = sw_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'black'
      end
      unless bishop.nil?
        return condition = 'check' if free_path?(king.x, king.y, bishop.x, bishop.y)
      end

    elsif king.color == 'black'

      # nw path
      bishop = nw_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'white'
      end
      unless bishop.nil?
        return condition = 'check' if free_path?(king.x, king.y, bishop.x, bishop.y)
      end

      # ne path
      bishop = ne_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'white'
      end
      unless bishop.nil?
        return condition = 'check' if free_path?(king.x, king.y, bishop.x, bishop.y)
      end

      # se path
      bishop = se_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'white'
      end
      unless bishop.nil?
        return condition = 'check' if free_path?(king.x, king.y, bishop.x, bishop.y)
      end

      # sw path
      bishop = sw_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'white'
      end
      unless bishop.nil?
        return condition = 'check' if free_path?(king.x, king.y, bishop.x, bishop.y)
      end

    end
    condition
  end

  def queen_check(king)
    # left path
    left_path = []
    detect_path(king.x, king.y, 1, king.y).each { |s| left_path << s }

    # right path
    right_path = []
    detect_path(king.x, king.y, 8, king.y).each { |s| right_path << s }

    # up path
    up_path = []
    detect_path(king.x, king.y, king.x, 8).each { |s| up_path << s }

    # down path
    down_path = []
    detect_path(king.x, king.y, king.x, 1).each { |s| down_path << s }

    # nw path
    nw_path = []
    x2 = king.x
    y2 = king.y
    until x2 == 8 || y2 == 8
      x2 += 1
      y2 += 1
    end
    detect_path(king.x, king.y, x2, y2).each { |s| nw_path << s }

    # ne path
    ne_path = []
    x2 = king.x
    y2 = king.y
    until x2 == 1 || y2 == 8
      x2 -= 1
      y2 += 1
    end
    detect_path(king.x, king.y, x2, y2).each { |s| ne_path << s }

    # sw path
    sw_path = []
    x2 = king.x
    y2 = king.y
    until x2 == 1 || y2 == 1
      x2 -= 1
      y2 -= 1
    end
    detect_path(king.x, king.y, x2, y2).each { |s| sw_path << s }

    # se path
    se_path = []
    x2 = king.x
    y2 = king.y
    until x2 == 8 || y2 == 1
      x2 += 1
      y2 -= 1
    end
    detect_path(king.x, king.y, x2, y2).each { |s| se_path << s }

    condition = 'nope'

    if king.color == 'white'
      # left path
      queen = left_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

      # right_path
      queen = right_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

      # up path
      queen = up_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

      # down path
      queen = down_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

      # nw path
      queen = nw_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

      # ne path
      queen = ne_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

      # se path
      queen = se_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

      # sw path
      queen = sw_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

    elsif king.color == 'black'

      # left path
      queen = left_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

      # right_path
      queen = right_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

      # up path
      queen = up_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

      # down path
      queen = down_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

      # nw path
      queen = nw_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

      # ne path
      queen = ne_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

      # se path
      queen = se_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

      # sw path
      queen = sw_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        return condition = 'check' if free_path?(king.x, king.y, queen.x, queen.y)
      end

    end
    condition
  end

  # based on player turn: king = detect white or black king
  # rewrite pawn_check as a single method
  def check?(king)
    if pawn_check(king) == 'check'
      return true
    elsif rook_check(king) == 'check'
      return true
    elsif knight_check(king) == 'check'
      return true
    elsif bishop_check(king) == 'check'
      return true
    elsif queen_check(king) == 'check'
      return true
    else
      return false
    end
  end

  def enter_x1
    puts 'Enter x1'
    gets.chomp.to_i
  end

  def enter_y1
    puts 'Enter y1'
    gets.chomp.to_i
  end

  def enter_x2
    puts 'Enter x2'
    gets.chomp.to_i
  end

  def enter_y2
    puts 'Enter y2'
    gets.chomp.to_i
  end

  def play_turn_white
    puts "\nWHITE TURN"
    x1 = enter_x1 until (1..9).include?(x1)
    y1 = enter_y1 until (1..9).include?(y1)
    x2 = enter_x2 until (1..9).include?(x2)
    y2 = enter_y2 until (1..9).include?(y2)

    make_move(x1, y1, x2, y2)
    puts 'Check' if check?(detect_black_king)

    display_board
  end

  def play_turn_black
    puts "\nBLACK TURN"
    x1 = enter_x1 until (1..9).include?(x1)
    y1 = enter_y1 until (1..9).include?(y1)
    x2 = enter_x2 until (1..9).include?(x2)
    y2 = enter_y2 until (1..9).include?(y2)

    make_move(x1, y1, x2, y2)
    puts 'Check' if check?(detect_white_king)

    display_board
  end

  def play
    play_turn_white
    play_turn_black
  end
end

# game = Game.new
# game.display_board
# game.play while true