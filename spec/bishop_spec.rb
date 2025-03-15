require_relative '../lib/pieces/bishop'
require_relative '../lib/board'
describe Bishop do
  context 'finds all possible moves with an empty board' do
    let(:bishop_empty_moves) { Bishop.new }
    empty_board_bishop = Array.new(8) { Array.new(8, 'empty') }

    it 'finds the right upward line' do
      result_array = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]]
      expect(bishop_empty_moves.possible_moves([0, 0], empty_board_bishop)).to match_array(result_array)
    end
    it 'finds the right downward line' do
      result_array = [[1, 6], [2, 5], [3, 4], [4, 3], [5, 2], [6, 1], [7, 0]]
      expect(bishop_empty_moves.possible_moves([0, 7], empty_board_bishop)).to match_array(result_array)
    end
    it 'finds the left upward line' do
      result_array = [[6, 1], [5, 2], [4, 3], [3, 4], [2, 5], [1, 6], [0, 7]]
      expect(bishop_empty_moves.possible_moves([7, 0], empty_board_bishop)).to match_array(result_array)
    end
    it 'finds the left downward line' do
      result_array = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [0, 0]]
      expect(bishop_empty_moves.possible_moves([7, 7], empty_board_bishop)).to match_array(result_array)
    end
  end
  context 'gets blocked by other pieces' do
    let(:bishop_blocked_moves) { Bishop.new }
    full_board_black = Array.new(8) { Array.new(8, Bishop.new) }
    full_board_white = Array.new(8) { Array.new(8, Bishop.new('white')) }

    it "can't move when surrounded by pieces from the same color" do
      expect(bishop_blocked_moves.possible_moves([4, 4], full_board_black)).to match_array([])
    end
    it 'can only move to were there are pieces of the same color and not further' do
      result_array = [[5, 5], [3, 5], [5, 3], [3, 3]]
      expect(bishop_blocked_moves.possible_moves([4, 4], full_board_white)).to match_array(result_array)
    end
  end
end
