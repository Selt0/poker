class Card

  attr_reader :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
    @face_down = true
  end

  def reveal
    @face_down = false
  end
end