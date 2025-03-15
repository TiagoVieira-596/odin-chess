require_relative '../lib/pieces/pawn'
require_relative '../lib/board'
describe Pawn do
  context 'finds the correct possible moves for the pawn' do
    let(:pawn_moves) { Pawn.new }
    empty_board_pawn = Array.new(8) { Array.new(8, 'empty') }
    full_board_pawn = Array.new(8) { Array.new(8, Pawn.new('white')) }

    it 'finds only forward moves with an empty board' do
      expect(pawn_moves.possible_moves([1, 1], empty_board_pawn)).to match_array([[1, 2], [1, 3]])
    end
    it 'does not show moves off the board with a full board' do
      expect(pawn_moves.possible_moves([0, 0], full_board_pawn)).to match_array([[1, 1]])
    end
    it 'finds the 2 taking moves with a full board' do
      expect(pawn_moves.possible_moves([1, 1], full_board_pawn)).to match_array([[0, 2], [2, 2]])
    end
  end
  context 'gets blocked by other pieces' do
    let(:pawn_blocked_moves) { Pawn.new }
    full_board_black = Array.new(8) { Array.new(8, Pawn.new) }
    full_board_white = Array.new(8) { Array.new(8, Pawn.new('white')) }

    it "can't move when surrounded by pieces from the same color" do
      expect(pawn_blocked_moves.possible_moves([4, 4], full_board_black)).to match_array([])
    end
    it 'can only move to were there are pieces of the same color and not further' do
      result_array = [[5, 5], [3, 5]]
      expect(pawn_blocked_moves.possible_moves([4, 4], full_board_white)).to match_array(result_array)
    end
  end
end
