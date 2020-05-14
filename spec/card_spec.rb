require 'rspec'
require 'card'

describe Card do 
  describe '#initialize' do
    subject(:card) { Card.new(10, '♥') }

    it 'sets up a card correctly' do
      expect(card.suit).to eq('♥')
      expect(card.value).to eq(10)
    end
  end
end