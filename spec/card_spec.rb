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
end