class ChessBoard
  attr_accessor :board

  def initialize
    @board = Array.new(8) { {} }
    populate_new_board
  end

  def layout
    layout = "_ _ _ _ _ _ _ _\n"
    board.reverse.each do |row|
      row_string = ''
      row.sort.to_h.each_value { |piece| row_string += "| #{piece} " }
      layout += "#{row_string}|\n"
    end
    layout += '_ _ _ _ _ _ _ _'
  end

  def populate_new_board
    (0..7).each do |column|
      @board[1][column] = 'black_pawn'
      @board[6][column] = 'white_pawn'
      (2..5).each { |row| @board[row][column] = 'empty' }
    end
    address = 0
    pieces_order = %w[rook knight bishop queen king]
    pieces_order.each do |piece|
      @board[0][address] = "black_#{piece}"
      @board[7][address] = "white_#{piece}"
      unless %w[queen king].include?(piece)
        @board[0][7 - address] = "white_#{piece}"
        @board[7][7 - address] = "black_#{piece}"
      end
      address += 1
    end
  end
end

game = ChessBoard.new
game.populate_new_board
print game.layout
