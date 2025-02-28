Dir[File.join(File.dirname(__FILE__), '../lib/pieces/*.rb')].each { |file| require file }
require_relative '../lib/board'
describe Piece do
  context 'to_s works correctly on piece classes' do
    let(:knight_print) {Knight.new('black', 'knight')}
    let(:pawn_print) {Pawn.new('white', 'pawn')}
    let(:bad_input_print) {Pawn.new('white', '')}

    it "prints black_knight as \u{265E}" do
      expect(knight_print.to_s).to eq("\u{265E}")
    end
    it "prints white_pawn as \u{2659}" do
      expect(pawn_print.to_s).to eq("\u{2659}")
    end
    it 'returns nil when missing a piece name' do
      expect(bad_input_print.to_s).to eq(nil)
    end
  end
end

describe Knight do
  context 'finds the correct possible moves for the knight' do
    let(:knight_moves) {Knight.new('knight')}

    it  'finds all possible 8 moves' do
      expect(knight_moves.possible_moves([3,3])).to match_array([[5, 2], [5, 4], [4, 1], [4, 5], [2, 1], [2, 5], [1, 2], [1, 4]])
    end
    it  'does not show moves off the board' do
      expect(knight_moves.possible_moves([0, 0])).to match_array([[1, 2], [2, 1]])
    end
  end
end

describe Pawn do
  context 'finds the correct possible moves for the pawn' do
    let(:pawn_moves) {Pawn.new('pawn')}
    empty_board = Array.new(8) { Array.new(8, 'empty')}
    full_board = Array.new(8) { Array.new(8, '-')}

    it  'finds only forward moves with an empty board' do
      expect(pawn_moves.possible_moves([1,1], empty_board)).to match_array([[1, 2], [1, 3]])
    end
    it  'does not show moves off the board with a full board' do
      expect(pawn_moves.possible_moves([0, 0], full_board)).to match_array([[0, 2], [0, 1], [1, 1]])
    end
    it  'finds all possible 4 moves with a full board' do
      expect(pawn_moves.possible_moves([1,1], full_board)).to match_array([[0, 2], [1, 2], [2, 2], [1, 3]])
    end
  end
end