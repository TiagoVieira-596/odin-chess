require_relative '../lib/pieces/knight'
require_relative '../lib/board'
describe Knight do
  context 'finds the correct possible moves for the knight' do
    let(:knight_moves) { Knight.new('knight') }
    empty_knight_board = Array.new(8) { Array.new(8, 'empty') }

    it 'finds all possible 8 moves' do
      result_array = [[5, 2], [5, 4], [4, 1], [4, 5], [2, 1], [2, 5], [1, 2], [1, 4]]
      expect(knight_moves.possible_moves([3, 3], empty_knight_board)).to match_array(result_array)
    end
    it 'does not show moves off the board_castle' do
      expect(knight_moves.possible_moves([0, 0], empty_knight_board)).to match_array([[1, 2], [2, 1]])
    end
  end
  context 'gets blocked by other pieces' do
    let(:knight_blocked_moves) { Knight.new('knight') }
    full_board_black = Array.new(8) { Array.new(8, Knight.new('knight')) }

    it "can't move when surrounded by pieces from the same color" do
      expect(knight_blocked_moves.possible_moves([4, 4], full_board_black)).to match_array([])
    end
  end
end
