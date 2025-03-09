require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'
require_relative 'pieces/piece'
require_relative 'pieces/queen'
require_relative 'pieces/rook'

class ChessBoard
  attr_accessor :board

  def initialize
    @board = Array.new(8) { {} }
    populate_new_board
  end

  def layout
    layout = "+---+---+---+---+---+---+---+---+\n"
    board.reverse.each do |row|
      row_string = ''
      row.sort.to_h.each_value do |piece|
        piece = ' ' if piece == 'empty'
        row_string += "| #{piece} "
      end
      layout += "#{row_string}|\n"
      layout += "+---+---+---+---+---+---+---+---+\n"
    end
    layout
  end

  def populate_new_board
    (0..7).each do |column|
      @board[1][column] = Pawn.new('black', 'pawn')
      @board[6][column] = Pawn.new('white', 'pawn')
      (2..5).each { |row| @board[row][column] = 'empty' }
    end
    address = 0
    pieces_order = [Rook, Knight, Bishop, Queen, King]
    pieces_order.each do |piece|
      @board[0][address] = piece.new('black', piece.to_s.downcase)
      @board[7][address] = piece.new('white', piece.to_s.downcase)
      unless [Queen, King].include?(piece)
        @board[0][7 - address] = piece.new('black', piece.to_s.downcase)
        @board[7][7 - address] = piece.new('white', piece.to_s.downcase)
      end
      address += 1
    end
  end
end

board = ChessBoard.new
print board.layout
