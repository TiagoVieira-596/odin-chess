require_relative '../lib/pieces/knight'
require_relative '../lib/board'
describe Knight do
  context 'finds the correct possible moves for the knight' do
    let(:knight_moves) { Knight.new('knight') }
    empty_knight_board = Array.new(8) { Array.new(8, 'empty') }

    it 'finds all possible 8 moves' do
      expect(knight_moves.possible_moves([3,
                                          3], empty_knight_board)).to match_array([[5, 2], [5, 4], [4, 1], [4, 5], [2, 1], [2, 5], [1, 2],
                                                                                   [1, 4]])
    end
    it 'does not show moves off the board_castle' do
      expect(knight_moves.possible_moves([0, 0], empty_knight_board)).to match_array([[1, 2], [2, 1]])
    end
  end
end
