require_relative '../lib/pieces/king'
require_relative '../lib/board'
describe King do
  context 'finds the possible castle moves' do
    let(:king_castles) { King.new('king') }
    board_castle = Array.new(8) { {} }
    board_castle[0][4] = King.new('black', 'king')

    it 'finds both moves when the spaces are empty and no piece has been moved' do
      (1..6).each do |space|
        board_castle[0][space] = 'empty' unless space == 4
      end
      board_castle[0][7] = King.new('black', 'king')
      board_castle[0][0] = King.new('black', 'king')
      expect(king_castles.possible_castle([4, 0], board_castle)).to match_array([[6, 0], [1, 0]])
    end
    it 'finds no moves when the spaces are empty and the kings have been moved' do
      (1..6).each do |space|
        board_castle[0][space] = 'empty' unless space == 4
      end
      board_castle[0][7] = King.new('black', 'king')
      board_castle[0][7].was_moved = true
      board_castle[0][0] = King.new('black', 'king')
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
      board_castle[0][7] = King.new('black', 'king')
      board_castle[0][0] = King.new('black', 'king')
      expect(king_castles.possible_castle([4, 0], board_castle)).to match_array([])
    end
    it 'can find only one move' do
      (5..6).each do |space|
        board_castle[0][space] = 'empty'
      end
      board_castle[0][4] = King.new('black', 'king')
      board_castle[0][7] = King.new('black', 'king')
      board_castle[0][0] = 'empty'
      expect(king_castles.possible_castle([4, 0], board_castle).flatten).to match_array([6, 0])
    end
  end
  context 'finds possible moves' do
    let(:king_moves) { King.new('king') }
    board_moves = Array.new(8) { Array.new(8, 'empty') }
    board_moves[0][4] = King.new('black', 'king')

    it 'does not find moves off the board' do
      (0..7).each do |space|
        board_moves[0][space] = 'empty' unless space == 4
      end
      result_array = [[3, 0], [3, 1], [4, 1], [5, 1], [5, 0]]
      expect(king_moves.possible_moves([4, 0], board_moves)).to match_array(result_array)
    end
    it 'includes castle moves' do
      (0..6).each do |space|
        board_moves[0][space] = 'empty' unless space == 4
      end
      board_moves[0][7] = King.new('king')
      result_array = [[3, 0], [3, 1], [4, 1], [5, 1], [5, 0], [6, 0]]
      expect(king_moves.possible_moves([4, 0], board_moves)).to match_array(result_array)
    end
    it 'finds all the 8 possible moves' do
      (0..7).each do |space|
        board_moves[0][space] = 'empty'
      end
      board_moves[1][4] = King.new('king')
      board_moves[1][4].was_moved = true
      result_array = [[3, 1], [3, 2], [4, 2], [5, 2], [5, 1], [5, 0], [4, 0], [3, 0]]
      expect(king_moves.possible_moves([4, 1], board_moves)).to match_array(result_array)
    end
  end
  context 'gets blocked by other pieces' do
    let(:king_blocked_moves) { King.new('king') }
    full_board_black = Array.new(8) { Array.new(8, King.new('king')) }
    full_board_white = Array.new(8) { Array.new(8, King.new('white', 'king')) }

    it "can't move when surrounded by pieces from the same color" do
      expect(king_blocked_moves.possible_moves([4, 4], full_board_black)).to match_array([])
    end
    it 'can only move to were there are pieces of the same color' do
      result_array = [[3, 4], [4, 5], [5, 4], [4, 3], [5, 5], [3, 3], [3, 5], [5, 3]]
      expect(king_blocked_moves.possible_moves([4, 4], full_board_white)).to match_array(result_array)
    end
  end
end
