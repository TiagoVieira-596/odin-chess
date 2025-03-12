Dir.glob(File.join(__dir__, 'pieces', '*.rb')).each { |file| require_relative file }

class ChessBoard
  attr_accessor :board, :moves_made

  def initialize
    @board = Array.new(8) { {} }
    populate_new_board
    @moves_made = 0
  end

  def layout
    layout = "+--+--+--+--+--+--+--+--+\n"
    board.reverse.each do |row|
      row_string = ''
      row.sort.to_h.each_value do |piece|
        piece = ' ' if piece == 'empty'
        row_string += "|#{piece} "
      end
      layout += "#{row_string}|\n"
      layout += "+--+--+--+--+--+--+--+--+\n"
    end
    layout
  end

  def all_pieces(&block)
    @board.each do |row|
      row.each_value(&block)
    end
  end

  def find_pieces_addresses(piece, color)
    piece_class = Object.const_get(piece.downcase.capitalize)
    piece_addresses = []
    @board.each_with_index do |row, index|
      column_index = 0
      row.sort.to_h.each_value do |piece|
        piece_addresses << [column_index, index] if (piece.is_a? piece_class) && piece.color == color
        column_index += 1
      end
    end
    piece_addresses
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
