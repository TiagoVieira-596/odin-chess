require_relative '../lib/pieces/piece'
require_relative '../lib/board'
describe Piece do
  context 'to_s works correctly on piece classes' do
    let(:knight_print) { Knight.new('black', 'knight') }
    let(:pawn_print) { Pawn.new('white', 'pawn') }
    let(:bad_input_print) { Pawn.new('white', '') }

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
