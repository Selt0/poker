require_relative 'card'

class Deck

  attr_reader :deck

  CARDS = [:A, :K, :Q, :J, 10, 9, 8, 7, 6, 5, 4, 3, 2]

  SUITS = ['♧', '♢', '♥', '♤']

  def initialize
    @deck = SUITS.map do |suit|
        CARDS.map do |card|
          Card.new(card, suit)
        end
      end
  end

end