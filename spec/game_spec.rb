require_relative '../lib/game'

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

  describe "#detect_piece" do
    subject(:game_piece) { described_class.new }

    context 'when selecting a square' do
      it 'returns the piece type found in the square' do
        board = game_piece.instance_variable_get(:@board)
        expect(game_piece.detect_piece(2, 1)).to eq('knight')
      end
    end
  end

  describe "#check_pawn_move" do
    subject(:game_move) { described_class.new }

    context 'when wanting to move a pawn' do
      it 'gives an error message if the move is not allowed' do
        output = game_move.check_pawn_move(1, 2, 1, 6)
        expect(output).to eq('Invalid move for the type')
      end
    end
  end
end