require_relative '../lib/board'

describe ChessBoard do

  describe "#create_board" do
    subject(:clean_board) { described_class.new }

    context 'when the board is first created' do
      it 'places the pieces in their correct places' do
        board = clean_board.instance_variable_get(:@board)
        white_king_pos = board.detect { |s| s.state == "\u265A" }
        expect([white_king_pos.x, white_king_pos.y]).to eq([5, 1])
      end
    end
  end
end
