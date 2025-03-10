require_relative 'piece'
require_relative 'rook'
require_relative 'bishop'
class Queen < Piece
  # uses and returns [x, y] board notation
  # the board class uses [y, x] access
  def possible_moves(start, board)
    possible_moves = []
    rook_instance = Rook.new(color.to_s, 'rook')
    bishop_instance = Bishop.new(color.to_s, 'bishop')
    rook_instance.possible_moves(start, board).each { |horizontal_move| possible_moves << horizontal_move }
    bishop_instance.possible_moves(start, board).each { |diagonal_move| possible_moves << diagonal_move }
    possible_moves
  end
end
