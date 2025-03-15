require_relative '../lib/pieces/rook'
require_relative '../lib/board'
describe Rook do
  context 'finds all possible moves with an empty board' do
    let(:rook_empty_moves) { Rook.new }
    empty_board_rook = Array.new(8) { Array.new(8, 'empty') }

    it 'finds the right and upward lines' do
      result_array = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0],
                      [6, 0], [7, 0]]
      expect(rook_empty_moves.possible_moves([0, 0], empty_board_rook)).to match_array(result_array)
    end
    it 'finds the left and downward lines' do
      result_array = [[0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 0], [7, 1], [7, 2], [7, 3], [7, 4],
                      [7, 5], [7, 6]]
      expect(rook_empty_moves.possible_moves([7, 7], empty_board_rook)).to match_array(result_array)
    end
  end
  context 'gets blocked by other pieces' do
    let(:rook_blocked_moves) { Rook.new }
    full_board_black = Array.new(8) { Array.new(8, Rook.new) }
    full_board_white = Array.new(8) { Array.new(8, Rook.new('white')) }

    it "can't move when surrounded by pieces from the same color" do
      expect(rook_blocked_moves.possible_moves([4, 4], full_board_black)).to match_array([])
    end
    it 'can only move to were there are pieces of the same color and not further' do
      result_array = [[3, 4], [4, 5], [5, 4], [4, 3]]
      expect(rook_blocked_moves.possible_moves([4, 4], full_board_white)).to match_array(result_array)
    end
  end
end
