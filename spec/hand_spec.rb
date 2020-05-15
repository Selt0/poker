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

      context "when straight" do
        let(:ace_straight) do
          Hand.new([
            Card.new(:A, :hearts),
            Card.new(2, :spades),
            Card.new(3, :hearts),
            Card.new(4, :hearts),
            Card.new(5, :hearts)
          ])
        end

        it "should allow ace as the low card" do
          expect(ace_straight.rank).to eq(:straight)
        end
      end
    end

    describe "#<=>" do
      context "with a higher rank" do
        it "should return 1" do
          expect(royal_flush <=> straight_flush).to eq(1)
        end
      end

      context "with a lower rank" do
        it "should return -1" do
          expect(straight_flush <=> royal_flush).to eq(-1)
        end
      end

      context "with identical hands" do
        it "should return 0" do
          expect(straight_flush <=> straight_flush).to eq(0)
        end
      end

      context "when hands have the same rank (tie breaker)" do
        context "When royal flush" do
          let(:hearts_royal_flush) do
            Hand.new([
              Card.new(:A, :hearts),
              Card.new(:K, :hearts),
              Card.new(:Q, :hearts),
              Card.new(:J, :hearts),
              Card.new(10, :hearts)
            ])
          end

          let(:spades_royal_flush) do
            Hand.new([
              Card.new(:A, :spades),
              Card.new(:K, :spades),
              Card.new(:Q, :spades),
              Card.new(:J, :spades),
              Card.new(10, :spades)
            ])
          end
          
          it "compares based on suit" do
            expect(hearts_royal_flush <=> spades_royal_flush).to eq(-1)
            expect(spades_royal_flush <=> hearts_royal_flush).to eq(1)
          end
        end

        context "straight flush" do
          let(:straight_flush_eight) do
            Hand.new([
              Card.new(8, :spades),
              Card.new(7, :spades),
              Card.new(6, :spades),
              Card.new(5, :spades),
              Card.new(4, :spades)
            ])
          end

          let(:straight_flush_nine) do
            Hand.new([
              Card.new(9, :spades),
              Card.new(8, :spades),
              Card.new(7, :spades),
              Card.new(6, :spades),
              Card.new(5, :spades)
            ])
          end

          let(:hearts_flush_nine) do
            Hand.new([
              Card.new(9, :hearts),
              Card.new(8, :hearts),
              Card.new(7, :hearts),
              Card.new(6, :hearts),
              Card.new(5, :hearts)
            ])
          end
          
          it "compares based on high card" do
            expect(straight_flush_nine <=> straight_flush_eight).to eq(1)
            expect(straight_flush_eight <=> straight_flush_nine).to eq(-1)
          end

          it "compares based on suit when high card is the same" do
            expect(straight_flush_nine <=> hearts_flush_nine).to eq(1)
            expect(hearts_flush_nine <=> straight_flush_nine).to eq(-1)
          end
        end

        context "when four of a kind" do
          let(:ace_four) do
            Hand.new([
              Card.new(:A, :spades),
              Card.new(:A, :hearts),
              Card.new(:A, :diamonds),
              Card.new(:A, :clubs),
              Card.new(10, :spades)
            ])
          end

          let(:king_four) do
            Hand.new([
              Card.new(:K, :spades),
              Card.new(:K, :hearts),
              Card.new(:K, :diamonds),
              Card.new(:K, :clubs),
              Card.new(10, :spades)
            ])
          end

          it "compares based on four of a kind value" do
            expect(ace_four <=> king_four).to eq(1)
            expect(king_four <=> ace_four).to eq(-1)
          end

          let(:ace_with_two) do
            Hand.new([
              Card.new(:A, :spades),
              Card.new(:A, :hearts),
              Card.new(:A, :diamonds),
              Card.new(:A, :clubs),
              Card.new(2, :spades)
            ])
          end

          context "if same four of four a kind value" do
            it "should compare based on high card value" do
              expect(ace_four <=> ace_with_two).to eq(1)
              expect(ace_with_two <=> ace_four).to eq(-1)
            end
          end

          let(:ace_with_two_hearts) do
            Hand.new([
              Card.new(:A, :spades),
              Card.new(:A, :hearts),
              Card.new(:A, :diamonds),
              Card.new(:A, :clubs),
              Card.new(2, :hearts)
            ])
          end

          context "if same high card value" do
            it "compares based on suit" do
              expect(ace_with_two <=> ace_with_two_hearts).to eq(1)
              expect(ace_with_two_hearts <=> ace_with_two).to eq(-1)
            end
          end
        end

        context "When two pair" do
          let(:two_pair_3_4) do
            Hand.new([
              Card.new(3, :spades),
              Card.new(3, :hearts),
              Card.new(4, :hearts),
              Card.new(4, :diamonds),
              Card.new(10, :hearts)
            ])
          end

          let(:two_pair_4_5) do
            Hand.new([
              Card.new(5, :spades),
              Card.new(5, :hearts),
              Card.new(4, :hearts),
              Card.new(4, :diamonds),
              Card.new(10, :hearts)
            ])
          end

          let(:pair_of_sixes) do
            Hand.new([
              Card.new(6, :spades),
              Card.new(6, :hearts),
              Card.new(4, :hearts),
              Card.new(5, :diamonds),
              Card.new(10, :hearts)
            ])
          end

          it "two pair beats one pair" do
            expect(two_pair_3_4 <=> pair_of_sixes).to eq(1)
          end

          context "if same number of pairs" do
            it "higher value of pair wins" do
              expect(two_pair_4_5 <=> two_pair_3_4).to eq(1)
            end
          end
        end

        context "When one pair" do
          let(:ace_pair) do
            Hand.new([
              Card.new(:A, :spades),
              Card.new(:A, :diamonds),
              Card.new(:Q, :hearts),
              Card.new(:J, :diamonds),
              Card.new(10, :hearts)
            ])
          end

          let(:king_pair) do
            Hand.new([
              Card.new(:K, :spades),
              Card.new(:K, :hearts),
              Card.new(9, :diamonds),
              Card.new(:J, :clubs),
              Card.new(10, :hearts)
            ])
          end

          let(:three_pair_jack_high) do
            Hand.new([
              Card.new(3, :spades),
              Card.new(3, :diamonds),
              Card.new(9, :clubs),
              Card.new(10, :hearts),
              Card.new(:J, :hearts)
            ])
          end

          let(:three_pair_king_high) do
            Hand.new([
              Card.new(3, :spades),
              Card.new(3, :diamonds),
              Card.new(9, :clubs),
              Card.new(10, :hearts),
              Card.new(:K, :hearts)
            ])
          end

          let(:four_pair) do
            Hand.new([
              Card.new(4, :spades),
              Card.new(4, :clubs),
              Card.new(9, :diamonds),
              Card.new(10, :hearts),
              Card.new(2, :hearts)
            ])
          end

          it "should compare based on pair value" do
            expect(ace_pair <=> king_pair).to eq(1)
            expect(four_pair <=> three_pair_jack_high).to eq(1)
          end

          let(:ace_pair_king_high) do
            Hand.new([
              Card.new(:A, :spades),
              Card.new(:A, :diamonds),
              Card.new(:K, :hearts),
              Card.new(:J, :diamonds),
              Card.new(10, :hearts)
            ])
          end

          context "If same pair value" do
            it "should compare based on high card" do
              expect(ace_pair_king_high <=> ace_pair).to eq(1)
              expect(three_pair_king_high <=> three_pair_jack_high).to eq(1)
            end
          end
        end

        context "When high card" do
          let(:ten_high) do
            Hand.new([
              Card.new(2, :spades),
              Card.new(4, :hearts),
              Card.new(6, :diamonds),
              Card.new(9, :spades),
              Card.new(10, :spades)
            ])
          end

          let(:king_high) do 
            Hand.new([
              Card.new(:K, :diamonds),
              Card.new(:J, :clubs),
              Card.new(9, :hearts),
              Card.new(4, :diamonds),
              Card.new(2, :spades)
            ])
          end

          it "should compare based on high card" do
            expect(king_high <=> ten_high).to eq(1)
            expect(ten_high <=> king_high).to eq(-1)
          end
        end
      end
    end
  end
end
