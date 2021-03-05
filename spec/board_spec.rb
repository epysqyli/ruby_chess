require_relative '../lib/board'

describe ChessBoard do

  describe "#create_board" do
    subject(:clean_board) { described_class.new }

    context 'when the board is first created' do
      it 'places the white king in its correct place' do
        board = clean_board.instance_variable_get(:@board)
        white_king_pos = board.detect { |s| s.state == "\u265A" }
        expect([white_king_pos.x, white_king_pos.y]).to eq([5, 1])
      end

      it 'places the black queen in its correct place' do
        board = clean_board.instance_variable_get(:@board)
        black_queen_pos = board.detect { |s| s.state == "\u2655" }
        expect([black_queen_pos.x, black_queen_pos.y]).to eq([4, 8])
      end
    end
  end
end
