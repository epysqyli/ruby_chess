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

  describe '#detect_path', :focus => true do
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

  describe "#check_piece_move" do
    subject(:game_move) { described_class.new }

    context 'when moving a pawn' do
      it 'gives an error message if the move is not allowed' do
        output = game_move.check_pawn_move(1, 2, 1, 6)
        expect(output).to eq('Invalid move for the type')
      end
    end

    context 'when moving a rook' do
      it 'gives an error message if the move is not allowed' do
        output = game_move.check_rook_move(1, 1, 4, 6)
        expect(output).to eq('Invalid move for the type')
      end
    end

    context 'when moving a knight' do
      it 'gives an error message if the move is not allowed' do
        output = game_move.check_knight_move(2, 1, 4, 6)
        expect(output).to eq('Invalid move for the type')
      end
    end

    context 'when moving a bishop' do
      it 'gives an error message if the move is not allowed' do
        output = game_move.check_bishop_move(3, 1, 6, 5)
        expect(output).to eq('Invalid move for the type')
      end
    end

    context 'when moving a queen' do
      it 'gives an error message if the move is not allowed' do
        output = game_move.check_queen_move(4, 1, 6, 5)
        expect(output).to eq('Invalid move for the type')
      end
    end

    context 'when moving a king' do
      it 'gives an error message if the move is not allowed' do
        output = game_move.check_king_move(5, 1, 5, 3)
        expect(output).to eq('Invalid move for the type')
      end
    end
  end

  describe '#check_move' do
    subject(:game_move) { described_class.new }

    context 'when a piece is to be moved' do
      it 'checks the move based on the piece type - pawn' do
        output = game_move.check_move(2, 2, 2, 3)
        expect(output).to eq('pawn')
      end

      it 'checks the move based on the piece type - rook' do
        output = game_move.check_move(1, 1, 1, 5)
        expect(output).to eq('rook')
      end

      it 'checks the move based on the piece type - knight' do
        output = game_move.check_move(2, 1, 1, 3)
        expect(output).to eq('knight')
      end

      it 'does not allow a move towards an occupied same player square' do
        output = game_move.check_move(1, 1, 2, 2)
        expect(output).to eq('same color')
      end
    end
  end
end