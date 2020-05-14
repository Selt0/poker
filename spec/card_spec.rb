require 'rspec'
require 'card'

describe Card do 
  describe '#initialize' do
    subject(:card) { Card.new(10, :hearts) }

    it 'sets up a card correctly' do
      expect(card.suit).to eq(:hearts)
      expect(card.value).to eq(10)
    end

    context 'invalid suit' do
      it 'raises an error' do
        expect { Card.new(10, :test) }.to raise_error(RuntimeError)
      end
    end

    context 'invalid value' do
      it 'raises an error' do
        expect { Card.new(20, :spades) }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#<=>' do
    context 'when cards are the same' do
      it 'should return 0' do
        expect(Card.new(10, :spades) <=> Card.new(10, :spades)).to eq(0)
      end
    end

    context 'when card has a higher value' do
      it 'should return 1' do
        expect(Card.new(:K, :diamonds) <=> Card.new(9, :diamonds)).to eq(1)
      end
    end

    context 'When card has a lower value or suit' do
      it 'should return -1' do
        expect(Card.new(:A, :hearts) <=> Card.new(:A, :spades)).to eq(-1)

        expect(Card.new(10, :spades) <=> Card.new(:A, :spades)).to eq(-1)
      end
    end
  end
end