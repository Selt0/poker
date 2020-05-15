class Card
  include Comparable

  CARD_VALUES = [2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K, :A]

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

  def self.royal_values
    CARD_VALUES[-5..-1]
  end

  attr_reader :value, :suit

  def initialize(value, suit)
    unless Card.suits.include?(suit) && Card.values.include?(value)
      raise "illegal suit (#{suit.inspect}) or value (#{value.inspect})"
    end

    @value, @suit = value, suit
  end

  def to_s
    value + SUIT_STRINGS[suit]
  end

  def ==(other_card)
    (self.suit == other_card.suit) && (self.value == other_card.value)
  end

  def <=>(other_card)
    if self == other_card
      0
    elsif value != other_card.value
      Card.values.index(value) <=> Card.values.index(other_card.value)
    elsif suit != other_card.suit
      Card.suits.index(suit) <=> Card.suits.index(other_card.suit)
    end
  end
end