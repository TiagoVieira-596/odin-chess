class Piece
  attr_accessor :was_moved, :address
  attr_reader :color, :name

  def initialize(color = 'black', address = [0, 0], name = self.class.name.downcase, was_moved = false)
    @color = color
    # uses [x, y] notation
    @address = address
    @name = name
    @was_moved = was_moved
  end

  def to_json(*_args)
    { type: self.class.name, color: @color, address: @address, name: @name, was_moved: @was_moved}.to_json
  end

  def to_s
    black_pieces = { 'king' => "\u{265A}", 'queen' => "\u{265B}", 'rook' => "\u{265C}", 'bishop' => "\u{265D}",
                     'knight' => "\u{265E}", 'pawn' => "\u{265F}" }
    white_pieces = { 'king' => "\u{2654}", 'queen' => "\u{2655}", 'rook' => "\u{2656}", 'bishop' => "\u{2657}",
                     'knight' => "\u{2658}", 'pawn' => "\u{2659}" }
    @color == 'black' ? black_pieces[@name] : white_pieces[@name]
  end
end
