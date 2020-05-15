require 'rspec'
require 'player'

describe Player do 
  subject(:player) { Player.new(100) }

  describe '::buy_in' do
    it "should create a new player" do
      expect(Player.buy_in(100)).to be_a(Player)
    end

    it "should set the players balance" do
      expect(Player.buy_in(100).balance).to eq(100)
    end
  end
end
