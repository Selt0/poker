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

  let(:cards) do
    [ double("card", :value => :K, :suit => :spades),
      double("card", :value => :Q, :suit => :spades),
      double("card", :value => :J, :suit => :spades)]
  end

  describe "#initialize" do
    context "no value given" do
      it "fills itself with 52 cards" do
        deck = Deck.new
        expect(deck.count).to eq(52)
      end
    end
    
    context "value given" do
      it "can be initialized with the array" do
        deck = Deck.new(cards)
        expect(deck.count).to eq(3)
      end
    end
  end

  let(:deck) { Deck.new(cards.dup) }

  it "should not expose its cards" do
    expect(deck).not_to respond_to(:cards)
  end

  describe "#take" do
    context "takes the cards" do
      it "should use the front of the cards array" do
        expect(deck.take(1)).to eq(cards[0..0])
        expect(deck.take(2)).to eq(cards[1..2])
      end

      it "rmoves cards from the deck" do
        deck.take(2)
        expect(deck.count).to eq(1)
      end

      context "when you take more cards than there are" do
        it "raises error" do
          expect { deck.take(4) }.to raise_error("not enough cards")
        end
      end
    end
  end
end