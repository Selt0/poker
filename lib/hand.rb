class Hand

  attr_reader :cards

  def initialize(cards)
    raise "must have 5 cards" unless cards.count == 5
    @cards = cards
  end
end