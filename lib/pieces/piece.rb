class Piece
  attr_accessor :was_moved
  attr_reader :color

  def initialize(color = 'black', name)
    @color = color
    @name = name
    @was_moved = false
  end

  def to_s
    black_pieces = { king: "\u{265A}", queen: "\u{265B}", rook: "\u{265C}", bishop: "\u{265D}",
                     knight: "\u{265E}", pawn: "\u{265F}" }
    white_pieces = { king: "\u{2654}", queen: "\u{2655}", rook: "\u{2656}", bishop: "\u{2657}",
                     knight: "\u{2658}", pawn: "\u{2659}" }
    @color == 'black' ? black_pieces[@name.to_sym] : white_pieces[@name.to_sym]
  end
end
