module TieBreaker
  def tie_breaker(other_hand)
    case rank
    when :royal_flush, :straight_flush, :straight, :flush, :high_card
      high_card <=> other_hand.high_card
    when :four_of_a_kind
      compare_set_then_high_card(4, other_hand)
    when :three_of_a_kind
      compare_set_then_high_card(3, other_hand)
    when :one_pair
      compare_set_then_high_card(2, other_hand)
    when :two_pair
      compare_two_pair(other_hand)
    when :full_house
      compare_full_house(other_hand)
    end
  end

  def compare_set_then_high_card(n, other_hand)
    set_card, other_set_card = set_card(n), other_hand.set_card(n)

    if set_card == other_set_card
      cards_without(set_card.value).last <=> other_hand.cards_without(set_card.value).last
    else
      set_card <=> other_set_card
    end
  end

  protected
  def pairs 
    pairs = []
    @cards.map(&:value).uniq.each do |value|
      if card_value_count(value) == 2
        pairs << @cards.select { |card| card.value == value }
      end
    end
    pairs
  end
end