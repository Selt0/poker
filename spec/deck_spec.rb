require 'rspec'
require 'deck'

describe Deck do 
  describe "::all_cards" do
    subject(:all_cards) { Deck.all_cards }

    it "should generate 52 cards" do
      expect(all_cards.count).to eq(52)
    end

    it "should create no duplicates" do
      expect(
        all_cards.map{ |card| [card.suit, card.value] }.uniq.count
      ).to eq(all_cards.count)
    end
  end