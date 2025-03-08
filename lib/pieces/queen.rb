require_relative 'piece'
require_relative 'tower'
require_relative 'bishop'
class Queen < Piece
  def possible_moves(start, board)
    possible_moves = []
    tower_instance = Tower.new(color.to_s, 'tower')
    bishop_instance = Bishop.new(color.to_s, 'bishop')
    tower_instance.possible_moves(start, board).each { |horizontal_move| possible_moves << horizontal_move }
    bishop_instance.possible_moves(start, board).each { |diagonal_move| possible_moves << diagonal_move }
    possible_moves
  end
end
