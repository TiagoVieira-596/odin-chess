Dir[File.join(File.dirname(__FILE__), '../lib/pieces/*.rb')].each { |file| require file }
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

describe Knight do
  context 'finds the correct possible moves for the knight' do
    let(:knight_moves) { Knight.new('knight') }

    it 'finds all possible 8 moves' do
      expect(knight_moves.possible_moves([3,
                                          3])).to match_array([[5, 2], [5, 4], [4, 1], [4, 5], [2, 1], [2, 5], [1, 2],
                                                               [1, 4]])
    end
    it 'does not show moves off the board_castle' do
      expect(knight_moves.possible_moves([0, 0])).to match_array([[1, 2], [2, 1]])
    end
  end
end

describe Pawn do
  context 'finds the correct possible moves for the pawn' do
    let(:pawn_moves) { Pawn.new('pawn') }
    empty_board_castle = Array.new(8) { Array.new(8, 'empty') }
    full_board_castle = Array.new(8) { Array.new(8, '-') }

    it 'finds only forward moves with an empty board_castle' do
      expect(pawn_moves.possible_moves([1, 1], empty_board_castle)).to match_array([[1, 2], [1, 3]])
    end
    it 'does not show moves off the board_castle with a full board_castle' do
      expect(pawn_moves.possible_moves([0, 0], full_board_castle)).to match_array([[0, 2], [0, 1], [1, 1]])
    end
    it 'finds all possible 4 moves with a full board_castle' do
      expect(pawn_moves.possible_moves([1, 1], full_board_castle)).to match_array([[0, 2], [1, 2], [2, 2], [1, 3]])
    end
  end
end

describe King do
  context 'finds the possible castle moves' do
    let(:king_castles) { King.new('king') }
    board_castle = Array.new(8) { {} }
    board_castle[0][4] = King.new('black', 'king')

    it 'finds both moves when the spaces are empty and no piece has been moved' do
      (1..6).each do |space|
        board_castle[0][space] = 'empty' unless space == 4
      end
      board_castle[0][7] = Tower.new('black', 'tower')
      board_castle[0][0] = Tower.new('black', 'tower')
      expect(king_castles.possible_castle([4, 0], board_castle)).to match_array([[0, 6], [0, 1]])
    end
    it 'finds no moves when the spaces are empty and the rooks have been moved' do
      (1..6).each do |space|
        board_castle[0][space] = 'empty' unless space == 4
      end
      board_castle[0][7] = Tower.new('black', 'tower')
      board_castle[0][7].was_moved = true
      board_castle[0][0] = Tower.new('black', 'tower')
      board_castle[0][0].was_moved = true
      expect(king_castles.possible_castle([4, 0], board_castle)).to match_array([])
    end
    it 'finds no moves when the spaces are empty and the king has been moved' do
      board_castle[0][4].was_moved = true
      expect(king_castles.possible_castle([4, 0], board_castle)).to match_array([])
    end
    it 'finds no moves when the spaces are full' do
      (1..6).each do |space|
        board_castle[0][space] = 'pawn' unless space == 4
      end
      board_castle[0][7] = Tower.new('black', 'tower')
      board_castle[0][0] = Tower.new('black', 'tower')
      expect(king_castles.possible_castle([4, 0], board_castle)).to match_array([])
    end
    it 'can find only one move' do
      (5..6).each do |space|
        board_castle[0][space] = 'empty'
      end
      board_castle[0][4] = King.new('black', 'king')
      board_castle[0][7] = Tower.new('black', 'tower')
      board_castle[0][0] = 'empty'
      expect(king_castles.possible_castle([4, 0], board_castle).flatten).to match_array([0, 6])
    end
  end
  context 'finds possible moves' do
    let(:king_moves) { King.new('king') }
    board_moves = Array.new(8) { {} }
    board_moves[0][4] = King.new('black', 'king')

    it 'does not find moves off the board' do
      (0..7).each do |space|
        board_moves[0][space] = 'empty' unless space == 4
      end
      expect(king_moves.possible_moves([4, 0], board_moves)).to match_array([[3, 0], [3, 1], [4, 1], [5, 1], [5, 0]])
    end
    it 'includes castle moves' do
      (0..6).each do |space|
        board_moves[0][space] = 'empty' unless space == 4
      end
      board_moves[0][7] = Tower.new('tower')
      expect(king_moves.possible_moves([4, 0],
                                       board_moves)).to match_array([[3, 0], [3, 1], [4, 1], [5, 1], [5, 0], [0, 6]])
    end
    it 'finds all the 8 possible moves' do
      (0..7).each do |space|
        board_moves[0][space] = 'empty'
      end
      board_moves[1][4] = King.new('king')
      board_moves[1][4].was_moved = true
      expect(king_moves.possible_moves([4, 1],
                                       board_moves)).to match_array([[3, 1], [3, 2], [4, 2], [5, 2], [5, 1], [5, 0],
                                                                     [4, 0], [3, 0]])
    end
  end
end
