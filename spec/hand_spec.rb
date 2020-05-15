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
  end
end
