require 'rspec'
require 'hand'
require 'card'

describe Hand do
  let(:cards) { [
                  Card.new(10, :spades),
                  Card.new(5, :hearts),
                  Card.new(:A, :hearts),
                  Card.new(2, :diamonds),
                  Card.new(2, :hearts)
              ] }
            
  subject(:hand) { Hand.new(cards) }

  describe '#initialize' do
    context 'if hand is not a total of 5 cards' do
      it "raises an error" do
        expect { Hand.new(cards[0..3]) }.to raise_error "must have 5 cards"
      end
    end

    it "accepts cards correctly" do
      expect(hand.cards).to match_array(cards)
    end
  end 

  describe '#trade_cards' do
    let!(:take_cards) { hand.cards[0..1] }
    let!(:new_cards) { [Card.new(5, :spades),
                        Card.new(3, :clubs)]}
      
    it "discards specified cards" do
      hand.trade_cards(take_cards, new_cards)
      expect(hand.cards).to_not include(*take_cards)
    end

    it "takes specified cards" do 
      hand.trade_cards(take_cards, new_cards)
      exoect(hand.cards).to include(*new_cards)
    end

    context "if trade does not result in 5 cards" do
      it "raises an error" do
        expect { hand.trade_cards(hand.cards[0..0], new_cards)}.to raise_error "must have 5 cards"
      end
    end

    context 'if trade tries to discard unowned card' do
      it "raises an error" do
        expect { hand.trade_cards([Card.new(10, :hearts)], new_cards[0..0]) }.to raise_error "cannot discard unowned card"
      end
    end
  end
end
