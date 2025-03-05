require_relative 'piece'
require_relative 'tower'
class King < Piece
  # uses and returns [x, y] board notation
  #the board class uses [y, x] access
  def possible_moves(start, board)
  end

  def possible_rocks(start, board)
    return nil if board[start[1]][start[0]].was_moved

    possible_rocks = []
    left_rock_possible = true
    right_rock_possible = true
    unless board[start[1]][start[0] + 3] == 'empty' || board[start[1]][start[0] + 3].was_moved
      (1..2).each do |space|
        unless board[start[1]][start[0] + space] == 'empty'
          right_rock_possible = false
        end
      end
    end

    unless board[start[1]][start[0] - 4] == 'empty' || board[start[1]][start[0] - 4].was_moved
      (1..3).each do |space|
        unless board[start[1]][start[0] - space] == 'empty'
          left_rock_possible = false
        end
      end
    end
    possible_rocks << [start[1], start[0] + 2] if right_rock_possible
    possible_rocks << [start[1], start[0] - 3] if left_rock_possible
  end
end

board = Array.new(8) { {} }
board[0][4] = King.new('black', 'king')
board[0][5] = 'empty'
board[0][6] = 'empty'
board[0][0] = 'empty'
board[0][7] = Tower.new('black', 'tower')
p board[0][4].possible_rocks([4, 0], board)