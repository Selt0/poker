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
      expect(hand.cards).to include(*new_cards)
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

  describe 'poker hands' do
    let(:royal_flush) do
      Hand.new([
        Card.new(:A, :spades),
        Card.new(:K, :spades),
        Card.new(:Q, :spades),
        Card.new(:J, :spades),
        Card.new(10, :spades)
      ])
    end

    let(:straight_flush) do
      Hand.new([
        Card.new(8, :spades),
        Card.new(7, :spades),
        Card.new(6, :spades),
        Card.new(5, :spades),
        Card.new(4, :spades)
      ])
    end

    let(:four_of_a_kind) do
      Hand.new([
        Card.new(:A, :spades),
        Card.new(:A, :hearts),
        Card.new(:A, :diamonds),
        Card.new(:A, :clubs),
        Card.new(10, :spades)
      ])
    end
      
    let(:full_house) do
      Hand.new([
        Card.new(:A, :spades),
        Card.new(:A, :clubs),
        Card.new(:K, :spades),
        Card.new(:K, :hearts),
        Card.new(:K, :diamonds)
      ])
    end
      
    let(:flush) do
      Hand.new([
        Card.new(4, :spades),
        Card.new(7, :spades),
        Card.new(:A, :spades),
        Card.new(2, :spades),
        Card.new(8, :spades)
      ])
    end

    let(:straight) do 
      Hand.new([
        Card.new(:K, :hearts),
        Card.new(:Q, :hearts),
        Card.new(:J, :diamonds),
        Card.new(10, :clubs),
        Card.new(9, :spades)
      ])
    end

    let(:three_of_a_kind) do
      Hand.new([
        Card.new(3, :spades),
        Card.new(3, :diamonds),
        Card.new(3, :hearts),
        Card.new(:J, :spades),
        Card.new(10, :spades)
      ])
    end

    let(:two_pair) do
      Hand.new([
        Card.new(:K, :hearts),
        Card.new(:K, :diamonds),
        Card.new(:Q, :spades),
        Card.new(:Q, :clubs),
        Card.new(10, :spades)
      ])
    end

    let(:one_pair) do
      Hand.new([
        Card.new(:A, :spades),
        Card.new(:A, :diamonds),
        Card.new(:Q, :hearts),
        Card.new(:J, :diamonds),
        Card.new(10, :hearts)
      ])
    end

    let(:high_card) do
      Hand.new([
        Card.new(10, :spades),
        Card.new(9, :spades),
        Card.new(6, :diamonds),
        Card.new(4, :hearts),
        Card.new(2, :spades)
      ])
    end

    let(:hand_ranks) do
      [
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
    end

    let!(:hands) do
      [
        royal_flush,
        straight_flush,
        four_of_a_kind,
        full_house,
        flush,
        straight,
        three_of_a_kind,
        two_pair,
        one_pair,
        high_card
      ]
    end

    describe 'rank' do
      it "should correctly identify the hand rank" do
        hands.each_with_index do |hand, i|
          expect(hand.rank).to eq(hand_ranks[i])
        end
      end
    end
  end
end
