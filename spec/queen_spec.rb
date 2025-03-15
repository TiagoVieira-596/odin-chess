require_relative '../lib/pieces/queen'
require_relative '../lib/board'
describe Queen do
  context 'finds all possible moves with an empty board' do
    let(:queen_empty_moves) { Queen.new }
    empty_board_queen = Array.new(8) { Array.new(8, 'empty') }

    it 'finds the the vertical upward, diagonal right upward and horizontal right lines' do
      result_array = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5],
                      [0, 6], [0, 7], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]]
      expect(queen_empty_moves.possible_moves([0, 0], empty_board_queen)).to match_array(result_array)
    end
    it 'finds the right downward line' do
      result_array = [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [1, 6], [1, 7], [2, 5], [2, 7], [3, 4],
                      [3, 7], [4, 3], [4, 7], [5, 2], [5, 7], [6, 1], [6, 7], [7, 0], [7, 7]]
      expect(queen_empty_moves.possible_moves([0, 7], empty_board_queen)).to match_array(result_array)
    end
    it 'finds the left upward line' do
      result_array = [[0, 0], [0, 7], [1, 0], [1, 6], [2, 0], [2, 5], [3, 0], [3, 4], [4, 0], [4, 3], [5, 0], [5, 2],
                      [6, 0], [6, 1], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7]]
      expect(queen_empty_moves.possible_moves([7, 0], empty_board_queen)).to match_array(result_array)
    end
    it 'finds the left downward line' do
      result_array = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [0, 0], [0, 7], [1, 7], [2, 7], [3, 7], [4, 7],
                      [5, 7], [6, 7], [7, 0], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6]]
      expect(queen_empty_moves.possible_moves([7, 7], empty_board_queen)).to match_array(result_array)
    end
  end
  context 'gets blocked by other pieces' do
    let(:queen_blocked_moves) { Queen.new }
    full_board_black = Array.new(8) { Array.new(8, Queen.new) }
    full_board_white = Array.new(8) { Array.new(8, Queen.new('white')) }

    it "can't move when surrounded by pieces from the same color" do
      expect(queen_blocked_moves.possible_moves([4, 4], full_board_black)).to match_array([])
    end
    it 'can only move to were there are pieces of the same color and not further' do
      result_array = [[5, 5], [3, 5], [5, 3], [3, 3], [3, 4], [4, 5], [5, 4], [4, 3]]
      expect(queen_blocked_moves.possible_moves([4, 4], full_board_white)).to match_array(result_array)
    end
  end
end
