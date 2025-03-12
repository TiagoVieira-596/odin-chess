require_relative 'piece'
require_relative 'rook'
class King < Piece
  # uses and returns [x, y] board notation
  # the board class uses [y, x] access
  def possible_moves(start = address, board)
    iteration = 0
    possible_moves = []
    x_moves = [-1, -1, 0, 1, 1, 1, 0, -1]
    y_moves = [0, 1, 1, 1, 0, -1, -1, -1]
    while iteration < 8
      x_position = x_moves[iteration] + start[0]
      y_position = y_moves[iteration] + start[1]
      unless (x_position >= 0 && x_position <= 7) && (y_position >= 0 && y_position <= 7)
        iteration += 1
        next
      end
      piece = board[y_position][x_position]

      possible_moves << [x_position, y_position] unless piece != 'empty' && piece.color == color
      iteration += 1
    end
    possible_castle(start, board).each { |castle| possible_moves << castle }
    possible_moves.delete_if { |address| address == [] }
  end

  def possible_castle(start, board)
    return [] if board[start[1]][start[0]].was_moved

    possible_castle = []
    left_rock_possible = false
    right_rock_possible = false
    unless board[start[1]][start[0] + 3] == 'empty' || board[start[1]][start[0] + 3].was_moved
      right_rock_possible = true
      (1..2).each do |space|
        right_rock_possible = false unless board[start[1]][start[0] + space] == 'empty'
      end
    end

    unless board[start[1]][start[0] - 4] == 'empty' || board[start[1]][start[0] - 4].was_moved
      left_rock_possible = true
      (1..3).each do |space|
        left_rock_possible = false unless board[start[1]][start[0] - space] == 'empty'
      end
    end
    possible_castle << [start[0] + 2, start[1]] if right_rock_possible
    possible_castle << [start[0] - 3, start[1]] if left_rock_possible
    possible_castle
  end
end
