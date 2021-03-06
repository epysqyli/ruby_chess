require_relative 'board'
require_relative 'player'

class Game
  attr_accessor :board

  @@threat_piece = nil
  @@game_over = false

  def initialize
    @board = ChessBoard.new.board
    #players not implemented as objects
    @white = Player.new('white')
    @black = Player.new('black')
  end

  def assign_threat(piece)
    @@threat_piece = piece
  end

  def get_threat
    @@threat_piece
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

    if path.empty?
      true
    elsif path.all? { |square| square.state == ' ' }
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

  ###########################
  # king check section begins
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
        if detect_piece(x, y) == 'pawn' && detect_color(x, y) == 'black'
          condition = 'check'
          assign_threat(detect_square(x, y))
        end
      end

    elsif king.color == 'black'
      moves = [[x + 1, y - 1], [x - 1, y - 1]]
      moves.select! { |move| move[0] < 9 && move[1] < 9 }
      moves.select! { |move| move[0] > 0 && move[1] > 0 }
      until condition == 'check' || moves.empty?
        move = moves.shift
        x = move[0]
        y = move[1]
        if detect_piece(x, y) == 'pawn' && detect_color(x, y) == 'white'
          condition = 'check'
          assign_threat(detect_square(x, y))
        end
      end
    end
    condition
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
        if detect_piece(x, y) == 'knight' && detect_color(x, y) == 'white'
          condition = 'check'
          assign_threat(detect_square(x, y))
        end
      end

    elsif king.color == 'white'
      until condition == 'check' || moves.empty?
        move = moves.shift
        x = move[0]
        y = move[1]
        if detect_piece(x, y) == 'knight' && detect_color(x, y) == 'black'
          condition = 'check'
          assign_threat(detect_square(x, y))
        end
      end
    end

    condition
  end

  def rook_check(king)
    left_path = []
    detect_path(king.x, king.y, 1, king.y).each { |s| left_path << s }

    right_path = []
    detect_path(king.x, king.y, 8, king.y).each { |s| right_path << s }

    up_path = []
    detect_path(king.x, king.y, king.x, 8).each { |s| up_path << s }

    down_path = []
    detect_path(king.x, king.y, king.x, 1).each { |s| down_path << s }

    condition = 'nope'

    if king.color == 'white'
      
      rook = left_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'black'
      end
      unless rook.nil?
        if free_path?(king.x, king.y, rook.x, rook.y)
          condition = 'check'
          assign_threat(rook)
        end
      end

      rook = right_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'black'
      end
      unless rook.nil?
        if free_path?(king.x, king.y, rook.x, rook.y)
          condition = 'check'
          assign_threat(rook)
        end
      end

      rook = up_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'black'
      end
      unless rook.nil?
        if free_path?(king.x, king.y, rook.x, rook.y)
          condition = 'check'
          assign_threat(rook)
        end
      end

      rook = down_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'black'
      end
      unless rook.nil?
        if free_path?(king.x, king.y, rook.x, rook.y)
          condition = 'check'
          assign_threat(rook)
        end
      end

    elsif king.color == 'black'

      rook = left_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'white'
      end
      unless rook.nil?
        if free_path?(king.x, king.y, rook.x, rook.y)
          condition = 'check'
          assign_threat(rook)
        end
      end

      rook = right_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'white'
      end
      unless rook.nil?
        if free_path?(king.x, king.y, rook.x, rook.y)
          condition = 'check'
          assign_threat(rook)
        end
      end

      rook = up_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'white'
      end
      unless rook.nil?
        if free_path?(king.x, king.y, rook.x, rook.y)
          condition = 'check'
          assign_threat(rook)
        end
      end

      rook = down_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'white'
      end
      unless rook.nil?
        if free_path?(king.x, king.y, rook.x, rook.y)
          condition = 'check'
          assign_threat(rook)
        end
      end

    end
    condition
  end

  def bishop_check(king)
    nw_path = []
    x2 = king.x
    y2 = king.y
    until x2 == 8 || y2 == 8
      x2 += 1
      y2 += 1
    end
    detect_path(king.x, king.y, x2, y2).each { |s| nw_path << s }

    ne_path = []
    x2 = king.x
    y2 = king.y
    until x2 == 1 || y2 == 8
      x2 -= 1
      y2 += 1
    end
    detect_path(king.x, king.y, x2, y2).each { |s| ne_path << s }

    sw_path = []
    x2 = king.x
    y2 = king.y
    until x2 == 1 || y2 == 1
      x2 -= 1
      y2 -= 1
    end
    detect_path(king.x, king.y, x2, y2).each { |s| sw_path << s }

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
        if free_path?(king.x, king.y, bishop.x, bishop.y)
          condition = 'check'
          assign_threat(bishop)
        end
      end

      # ne path
      bishop = ne_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'black'
      end
      unless bishop.nil?
        if free_path?(king.x, king.y, bishop.x, bishop.y)
          condition = 'check'
          assign_threat(bishop)
        end
      end

      # se path
      bishop = se_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'black'
      end
      unless bishop.nil?
        if free_path?(king.x, king.y, bishop.x, bishop.y)
          condition = 'check'
          assign_threat(bishop)
        end
      end

      # sw path
      bishop = sw_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'black'
      end
      unless bishop.nil?
        if free_path?(king.x, king.y, bishop.x, bishop.y)
          condition = 'check'
          assign_threat(bishop)
        end
      end

    elsif king.color == 'black'

      # nw path
      bishop = nw_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'white'
      end
      unless bishop.nil?
        if free_path?(king.x, king.y, bishop.x, bishop.y)
          condition = 'check'
          assign_threat(bishop)
        end
      end

      # ne path
      bishop = ne_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'white'
      end
      unless bishop.nil?
        if free_path?(king.x, king.y, bishop.x, bishop.y)
          condition = 'check'
          assign_threat(bishop)
        end
      end

      # se path
      bishop = se_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'white'
      end
      unless bishop.nil?
        if free_path?(king.x, king.y, bishop.x, bishop.y)
          condition = 'check'
          assign_threat(bishop)
        end
      end

      # sw path
      bishop = sw_path.detect do |square|
        detect_piece(square.x, square.y) == 'bishop' && detect_color(square.x, square.y) == 'white'
      end
      unless bishop.nil?
        if free_path?(king.x, king.y, bishop.x, bishop.y)
          condition = 'check'
          assign_threat(bishop)
        end
      end
    end

    condition
  end

  def queen_check(king)
    left_path = []
    detect_path(king.x, king.y, 1, king.y).each { |s| left_path << s }

    right_path = []
    detect_path(king.x, king.y, 8, king.y).each { |s| right_path << s }

    up_path = []
    detect_path(king.x, king.y, king.x, 8).each { |s| up_path << s }

    down_path = []
    detect_path(king.x, king.y, king.x, 1).each { |s| down_path << s }

    nw_path = []
    x2 = king.x
    y2 = king.y
    until x2 == 8 || y2 == 8
      x2 += 1
      y2 += 1
    end
    detect_path(king.x, king.y, x2, y2).each { |s| nw_path << s }

    ne_path = []
    x2 = king.x
    y2 = king.y
    until x2 == 1 || y2 == 8
      x2 -= 1
      y2 += 1
    end
    detect_path(king.x, king.y, x2, y2).each { |s| ne_path << s }

    sw_path = []
    x2 = king.x
    y2 = king.y
    until x2 == 1 || y2 == 1
      x2 -= 1
      y2 -= 1
    end
    detect_path(king.x, king.y, x2, y2).each { |s| sw_path << s }

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
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end

      # right_path
      queen = right_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)

        end
      end

      # up path
      queen = up_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end

      # down path
      queen = down_path.detect do |square|
        detect_piece(square.x, square.y) == 'rook' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end

      # nw path
      queen = nw_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end

      # ne path
      queen = ne_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end

      # se path
      queen = se_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end

      # sw path
      queen = sw_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'black'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end

    elsif king.color == 'black'

      # left path
      queen = left_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end

      # right_path
      queen = right_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end

      # up path
      queen = up_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end

      # down path
      queen = down_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end
      # nw path
      queen = nw_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end

      # ne path
      queen = ne_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end

      # se path
      queen = se_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end

      # sw path
      queen = sw_path.detect do |square|
        detect_piece(square.x, square.y) == 'queen' && detect_color(square.x, square.y) == 'white'
      end
      unless queen.nil?
        if free_path?(king.x, king.y, queen.x, queen.y)
          condition = 'check'
          assign_threat(queen)
        end
      end

    end
    condition
  end

  def check?(king)
    if pawn_check(king) == 'check'
      true
    elsif rook_check(king) == 'check'
      true
    elsif knight_check(king) == 'check'
      true
    elsif bishop_check(king) == 'check'
      true
    elsif queen_check(king) == 'check'
      true
    else
      false
    end
  end
  # king check section ends
  ##########################

  def pawn_check_reach(square)
    x = square.x
    y = square.y
    condition = 'nope'

    if square.color == 'white'
      moves = [[x, y + 1]]
      moves.select! { |move| move[0] < 9 && move[1] < 9 }
      moves.select! { |move| move[0] > 0 && move[1] > 0 }
      until condition == 'check' || moves.empty?
        move = moves.shift
        x = move[0]
        y = move[1]
        if detect_piece(x, y) == 'pawn' && detect_color(x, y) == 'black'
          condition = 'check'
          assign_threat(detect_square(x, y))
        end
      end

    elsif square.color == 'black'
      moves = [[x, y - 1]]
      moves.select! { |move| move[0] < 9 && move[1] < 9 }
      moves.select! { |move| move[0] > 0 && move[1] > 0 }
      until condition == 'check' || moves.empty?
        move = moves.shift
        x = move[0]
        y = move[1]
        if detect_piece(x, y) == 'pawn' && detect_color(x, y) == 'white'
          condition = 'check'
          assign_threat(detect_square(x, y))
        end
      end
    end
    condition
  end

  def allowed_king_moves(king)
    x = king.x
    y = king.y
    moves = [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1], [x + 1, y + 1], [x + 1, y - 1], [x - 1, y - 1], [x - 1, y + 1]]
    moves.select! { |move| move[0] < 9 && move[1] < 9 }
    moves.select! { |move| move[0] > 0 && move[1] > 0 }

    if king.color == 'white'
      moves.select! do |move|
        detect_piece(move[0], move[1]) == ' ' || detect_color(move[0], move[1]) == 'black'
      end

      # select away also those squares that are reached by enemy pieces
      # where the king could otherwise potentially move to
      # need to specify which color these squares would be based on the king color
      selected_square = detect_square(x, y)
      selected_square.state = ' '
      unless moves.empty?
        moves.map! do |move|
          square = detect_square(move[0], move[1])
          square.color = 'white'
          square
        end
        # select away those squares that are under threat, hence reachable by the enemy pieces
        #moves should also go through the king
        moves.select! { |square| check?(square) == false }
      end
      selected_square.state = "\u265A"

    elsif king.color == 'black'
      moves.select! do |move|
        detect_piece(move[0], move[1]) == ' ' || detect_color(move[0], move[1]) == 'white'
      end
      selected_square = detect_square(x, y)
      selected_square.state = ' '
      unless moves.empty?
        moves.map! do |move|
          square = detect_square(move[0], move[1])
          square.color = 'black'
          square
        end
        moves.select! { |square| check?(square) == false }
      end
      selected_square.state = "\u2654"
    end

    moves
  end

  # recycles incorrectly king check methods, semantically misleading
  def reachable?(square)
    if pawn_check_reach(square) == 'check'
      true
    elsif rook_check(square) == 'check'
      true
    elsif knight_check(square) == 'check'
      true
    elsif bishop_check(square) == 'check'
      true
    elsif queen_check(square) == 'check'
      true
    else
      false
    end
  end

  # do squares with color and without state need to be cleaned up?
  def breakable?(king, square)
    x1 = king.x
    y1 = king.y
    x2 = square.x
    y2 = square.y

    threat_path = detect_path(x1, y1, x2, y2)
    # puts "Printing threat path"
    # threat_path.each { |s| p s }

    condition = false

    if threat_path.length > 1 
      if king.color == 'white'
        threat_path.map { |square| square.color = 'black' }
        condition = true if threat_path.any? { |square| reachable?(square) == true }

      elsif king.color == 'black'
        threat_path.map { |square| square.color = 'white' }
        condition = true if threat_path.any? { |square| reachable?(square) == true }
      end
    end

    condition
  end

  def mate?(king, square)
    sum = 0

    allowed_king_moves(king).empty? ? sum += 1 : sum += 0
    # p allowed_king_moves(king)
    reachable?(square)? sum += 0 : sum += 1
    # p reachable?(square)
    breakable?(king, square)? sum += 0 : sum += 1
    # p breakable?(king, square)

    puts "GAME OVER" if sum == 3
    
    sum == 3 ? true : false
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
    if check?(detect_black_king) == true
      puts "\tcheck"
      @@game_over = true if mate?(detect_black_king, get_threat) == true
    else
      puts "\tno check"
    end

    display_board
  end

  def play_turn_black
    puts "\nBLACK TURN"
    x1 = enter_x1 until (1..9).include?(x1)
    y1 = enter_y1 until (1..9).include?(y1)
    x2 = enter_x2 until (1..9).include?(x2)
    y2 = enter_y2 until (1..9).include?(y2)

    make_move(x1, y1, x2, y2)
    if check?(detect_white_king) == true
      puts "\tcheck"
      @@game_over = true if mate?(detect_white_king, get_threat) == true
    else
      puts "\tno check"
    end

    display_board
  end

  def play
    until @@game_over == true
      play_turn_white
      break if @@game_over == true
      play_turn_black
      break if @@game_over == true
    end
  end
end

# game = Game.new
# game.display_board
# game.play
