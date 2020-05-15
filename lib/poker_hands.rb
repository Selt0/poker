module PokerHands

  RANKS = [
    :royal_flush,
    :straight_flush,
    :four_of_a_kind,
    :full_house,
    :flush,
    :straight,
    :three_of_a_kind,
    :two_pair,
    :one_pair,
    :high_card
  ]

  def rank
    RANKS.each { |rank| return rank if self.send("#{rank}?") }
  end
  
  protected
  def royal?
    Card.royal_values.all?{ |value| @cards.map(&:value).
    include?(value) }
  end

  def has_a?(value_or_suit)
    @cards.any? do |card|
      card.value == value_or_suit || card.suit == value_or_suit
    end
  end

  def card_value_count(value)
    @cards.map(&:value).count(value)
  end

  def pairs 
    pairs = []
    @cards.map(&:value).uniq.each do |value|
      if card_value_count(value) == 2
        pairs << @cards.select { |card| card.value == value }
      end
    end
    pairs
  end

  private
  def royal_flush?
    royal? && straight_flush?
  end

  def straight_flush?
    straight? && flush?
  end

  def straight?
    if has_a?(:A) && has_a?(2)
      straight = Card.values[0..3] + [:A]
    else
      low_index = Card.values.index(@cards.first.value)
      straight = Card.values[low_index..(low_index + 4)]
    end

    @cards.map(&:value) == straight
  end
  
  def flush?
    @cards.map(&:suit).uniq.length == 1
  end

  def four_of_a_kind?
    @cards.any?{ |card| card_value_count(card.value) == 4 }
  end

  def full_house?
    three_of_a_kind? && one_pair?
  end

  def three_of_a_kind?
    @cards.any? { |card| card_value_count(card.value) == 3 }
  end

  def one_pair?
   pairs.count == 1
  end

  def two_pair?
    pairs.count == 2
  end

  def high_card?
    true
  end
end