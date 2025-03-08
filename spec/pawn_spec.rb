require_relative '../lib/pieces/pawn'
require_relative '../lib/board'
describe Pawn do
  context 'finds the correct possible moves for the pawn' do
    let(:pawn_moves) { Pawn.new('pawn') }
    empty_board_pawn = Array.new(8) { Array.new(8, 'empty') }
    full_board_pawn = Array.new(8) { Array.new(8, Pawn.new('white', 'pawn')) }

    it 'finds only forward moves with an empty board' do
      expect(pawn_moves.possible_moves([1, 1], empty_board_pawn)).to match_array([[1, 2], [1, 3]])
    end
    it 'does not show moves off the board with a full board' do
      expect(pawn_moves.possible_moves([0, 0], full_board_pawn)).to match_array([[0, 2], [0, 1], [1, 1]])
    end
    it 'finds all possible 4 moves with a full board' do
      expect(pawn_moves.possible_moves([1, 1], full_board_pawn)).to match_array([[0, 2], [1, 2], [2, 2], [1, 3]])
    end
  end
end
