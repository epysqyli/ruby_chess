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

  describe "#identify_piece" do
    subject(:game_piece) { described_class.new }

    context 'when selecting a square' do
      xit 'returns the piece type found in the square' do
        board = game_piece.instance_variable_get(:@board)
        pos = board.detect { |square| [square.x, square.y] == [4, 1] }
        expect(game_piece.identify_piece(pos)).to eq('knight')
      end
    end
  end
end