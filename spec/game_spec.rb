require_relative '../lib/game'

RSpec.configure do |config|
  config.filter_run_when_matching(focus: true)
  config.example_status_persistence_file_path = 'spec/example.txt'
end

describe Game do
  describe "#initialize" do
    subject(:game_start) { described_class.new }

    context "when initialized" do
      it 'sets the right player colors' do
        white = game_start.instance_variable_get(:@white)
        black = game_start.instance_variable_get(:@black)
        expect([white.color, black.color]).to eq(['white', 'black'])
      end
    end
  end

  describe '#detect_square' do
    subject(:game_square) { described_class.new }

    it 'identifies and selects the desired square - white pawn' do
      x = 1
      y = 2
      square = game_square.detect_square(x, y)
      white_pawn = "\u265F"
      expect(square.state).to eq(white_pawn)
    end

    it 'identifies and selects the desired square - white king' do
      x = 5
      y = 1
      square = game_square.detect_square(x, y)
      white_king = "\u265A"
      expect(square.state).to eq(white_king)
    end
  end

  describe '#detect_color' do
    subject(:game_color) { described_class.new }

    it 'detects the color white of square [1, 1]' do
      color = game_color.detect_color(1, 1)
      expect(color).to eq('white')
    end

    it 'detects no color on square [4, 4]' do
      color = game_color.detect_color(4, 4)
      expect(color).to eq(' ')
    end
  end

  describe "#detect_piece" do
    subject(:game_piece) { described_class.new }

    context 'when selecting a square' do
      it 'returns the piece type found in the square' do
        board = game_piece.instance_variable_get(:@board)
        expect(game_piece.detect_piece(2, 1)).to eq('knight')
      end
    end
  end

  describe '#detect_path' do
    subject(:game_path) { described_class.new }

    context 'when moving a rook from [1, 1] to [1, 5]' do
      it 'lenght of the in between squares array is 3' do
        output = game_path.detect_path(1, 1, 1, 5)
        expect(output.length).to eq(3)
      end
    end

    context 'when moving a rook from [7, 6] to [7, 2]' do
      it 'lenght of the in between squares array is 3' do
        output = game_path.detect_path(7, 6, 7, 2)
        expect(output.length).to eq(3)
      end
    end

    context 'when moving a bishop from [3, 1] to [5, 3]' do
      it 'lenght of the in between squares array is 1' do
        output = game_path.detect_path(3, 1, 5, 3)
        expect(output.length).to eq(1)
      end
    end

    context 'when moving a bishop from [4, 4] to [6, 2]' do
      it 'lenght of the in between squares array is 1' do
        output = game_path.detect_path(4, 4, 6, 2)
        expect(output.length).to eq(1)
      end
    end
  end

  describe '#free_path?' do
    subject (:game_free_path) { described_class.new }

    it 'returns true when moving from [2, 2] to [2, 6]' do
      output = game_free_path.free_path?(2, 2, 2, 6)
      expect(output).to be_truthy
    end

    it 'returns false when moving from [2, 2] to [6, 2]' do
      output = game_free_path.free_path?(2, 2, 6, 2)
      expect(output).to be_falsy
    end
  end

  describe '#same_color?' do
    subject(:game_color_move) { described_class.new }

    context 'checking that the square is not occupied by a same color piece' do
      it 'returns true if there are same color pieces on both squares' do
        output = game_color_move.same_color?(1, 1, 2, 2)
        expect(output).to be_truthy
      end

      it 'returns false if there are different color pieces on both squares' do
        output = game_color_move.same_color?(1, 1, 7, 7)
        expect(output).to be_falsy
      end
    end
  end

  describe '#detect_white_king' do
    subject(:game_white_king) { described_class.new } 

    context 'wherever the white king is' do
      it 'detects the white king position' do
        white_king_pos = game_white_king.detect_white_king
        expect([white_king_pos.state, white_king_pos.color]).to eq(["\u265A", 'white'])
      end
    end
  end

  describe "#check_piece_move" do
    subject(:game_piece_move) { described_class.new }

    context 'when moving a pawn' do
      it 'gives an error message if the move is not allowed for the white pawn' do
        output = game_piece_move.check_pawn_move(1, 2, 1, 6)
        expect(output).to eq('Invalid move for the type')
      end

      it 'gives an error message if the move is not allowed for the black pawn' do
        output = game_piece_move.check_pawn_move(1, 7, 1, 4)
        expect(output).to eq('Invalid move for the type')
      end

      it 'returns allowed if the move is allowed for the white pawn' do
        output = game_piece_move.check_pawn_move(1, 2, 1, 4)
        expect(output).to eq('allowed')
      end

      it 'returns allowed if the move is allowed for the black pawn' do
        output = game_piece_move.check_pawn_move(1, 7, 1, 5)
        expect(output).to eq('allowed')
      end
    end

    context 'when using a pawn to eat another piece' do
      it 'cannot eat a black piece directly in front of a white one' do
        game_piece_move.make_move(4, 2, 4, 4)
        game_piece_move.make_move(4, 7, 4, 5)
        output = game_piece_move.detect_color(4, 5)
        game_piece_move.make_move(4, 4, 4, 5)
        expect(output).to eq('black')
      end

      it 'can eat a black piece diagonally with respect to a white one' do
        game_piece_move.make_move(4, 2, 4, 4)
        game_piece_move.make_move(3, 7, 3, 5)
        game_piece_move.make_move(4, 4, 3, 5)
        output = game_piece_move.detect_color(3, 5)
        expect(output).to eq('white')
      end

      it 'can eat a white piece diagonally with respect to a black one' do
        game_piece_move.make_move(3, 7, 3, 5)
        game_piece_move.make_move(4, 2, 4, 4)
        game_piece_move.make_move(3, 5, 4, 4)
        output = game_piece_move.detect_color(4, 4)
        expect(output).to eq('black')
      end
    end

    context 'when moving a rook' do
      it 'gives an error message if the move is not allowed' do
        output = game_piece_move.check_rook_move(1, 1, 4, 6)
        expect(output).to eq('Invalid move for the type')
      end
    end

    context 'when moving a knight' do
      it 'gives an error message if the move is not allowed' do
        output = game_piece_move.check_knight_move(2, 1, 4, 6)
        expect(output).to eq('Invalid move for the type')
      end
    end

    context 'when moving a bishop' do
      it 'gives an error message if the move is not allowed' do
        output = game_piece_move.check_bishop_move(3, 1, 6, 5)
        expect(output).to eq('Invalid move for the type')
      end
    end

    context 'when moving a queen' do
      it 'gives an error message if the move is not allowed' do
        output = game_piece_move.check_queen_move(4, 1, 6, 5)
        expect(output).to eq('Invalid move for the type')
      end
    end

    context 'when moving a king' do
      it 'gives an error message if the move is not allowed' do
        output = game_piece_move.check_king_move(5, 1, 5, 3)
        expect(output).to eq('Invalid move for the type')
      end
    end
  end

  describe '#make_move' do
    subject(:game_move) { described_class.new }

    context 'when making a legal move' do
      it 'updates the board accordingly , knight to [3, 3]' do
        game_move.make_move(2, 1, 3, 3)
        type = game_move.detect_piece(3, 3)
        expect(type).to eq('knight')
      end
    end

    context 'when trying to make a non-legal move' do
      it 'does not change the final square state' do
        game_move.make_move(2, 1, 7, 7)
        base_type = game_move.detect_piece(2, 1)
        arrive_type = game_move.detect_piece(7, 7)
        expect(arrive_type).not_to eq(base_type)
      end
    end         
  end

  describe '#pawn_check_white' do
    subject(:game_pawn_check) {described_class.new }

    context 'when the black pawn checks the white king' do
      it 'returns check condition for the white king' do
        square_5_1 = game_pawn_check.detect_square(5, 1)
        square_5_1.state = ' '
        square_5_1.color = ' '

        square_4_4 = game_pawn_check.detect_square(4, 4)
        square_4_4.state = "\u265A"
        square_4_4.color = 'white'

        square_5_5 = game_pawn_check.detect_square(5, 5)
        square_5_5.state= "\u2659"
        square_5_5.color = 'black'

        square_3_5 = game_pawn_check.detect_square(3, 5)
        square_3_5.state = "\u2659"
        square_3_5.color = 'black'

        output = game_pawn_check.pawn_check_white
        expect(output).to eq('check')
      end
    end
  end

  describe '#pawn_check_black' do
    subject(:game_pawn_check) {described_class.new }

    context 'when the white pawn checks the black king' do
      it 'returns check condition for the black king' do
        square_5_8 = game_pawn_check.detect_square(5, 8)
        square_5_8.state = ' '
        square_5_8.color = ' '

        square_5_5 = game_pawn_check.detect_square(5, 5)
        square_5_5.state = "\u2654"
        square_5_5.color = 'black'

        square_5_5 = game_pawn_check.detect_square(6, 4)
        square_5_5.state= "\u265F"
        square_5_5.color = 'white'

        square_3_5 = game_pawn_check.detect_square(4, 4)
        square_3_5.state = "\u265F"
        square_3_5.color = 'white'

        output = game_pawn_check.pawn_check_black
        expect(output).to eq('check')
      end
    end
  end

  describe '#knight_check', :focus => true do
    subject(:game_knight_check) { described_class.new }

    context 'when the white knight checks the black king' do
      it 'returns check condition for the black king' do
        king = game_knight_check.detect_black_king
        p king

        square_6_6 = game_knight_check.detect_square(6, 6)
        square_6_6.state = "\u265E"
        square_6_6.color = 'white'
        p square_6_6

        output = game_knight_check.knight_check(king)
        expect(output).to eq('check')
      end
    end
  end
end