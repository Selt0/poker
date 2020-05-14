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

  describe "#return" do
    let(:more_cards) do 
      [ double("card", :value => 5 , :suit => :hearts),
        double("card", :value => 6 , :suit => :hearts),
        double("card", :value => 7 , :suit => :hearts) ]
    end

    it "should return the cards to the deck" do
      deck.return(more_cards)
      expect(deck.count).to eq(6)
    end

    it "should not destroy the given array" do
      more_cards_dup = more_cards.dup
      deck.return(more_cards_dup)
      expect(more_cards_dup).to eq(more_cards)
    end

    it "should add new cards to the bottom of the deck" do
      deck.return(more_cards)
      deck.take(3)

      expect(deck.take(1)).to eq(more_cards[0..0])
      expect(deck.take(1)).to eq(more_cards[1..1])
      expect(deck.take(1)).to eq(more_cards[2..2])
    end
  end

  describe "#shuffle" do
    it "should shuffle the deck" do
      cards = deck.take(3)
      deck.return(cards)

      not_shuffled = (1..5).all? do
        deck.shuffle
        shuffled_Cards = deck.take(3)
        deck.return(shuffled_Cards)

        (0..2).all? { |i| shuffled_Cards[i] == cards[i] }
      end
      expect(not_shuffled).to be(false)
    end
  end
end