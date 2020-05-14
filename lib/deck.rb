require_relative 'card'

class Deck

  def self.all_cards
    deck = []
    Card::SUIT_STRINGS.keys.each do |suit|
      Card::CARD_VALUES.each do |value|
        deck << Card.new(value, suit)
      end
    end
    deck
  end

  def initialize (deck = Deck.all_cards)
    @deck = deck
  end

end