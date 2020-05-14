class Card

  CARD_VALUES = [:A, :K, :Q, :J, 10, 9, 8, 7, 6, 5, 4, 3, 2]

  SUIT_STRINGS = {
    :clubs => '♣',
    :diamonds => '♦',
    :hearts => '♥',
    :spades => '♠'
  }

  def self.suits
    SUIT_STRINGS.keys
  end

  def self.values
    CARD_VALUES
  end

  attr_reader :value, :suit

  def initialize(value, suit)
    unless Card.suits.include?(suit) && Card.values.include?(value)
      raise "illegal suit (#{suit.inspect}) or value (#{value.inspect})"
    end

    @value, @suit = value, suit
  end
end