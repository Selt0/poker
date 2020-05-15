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

  describe '#deal_in' do
    let(:hand) { double ('hand') }

    it "should set the players hand" do
      player.deal_in(hand)
      expect(player.hand).to eq(hand)
    end
  end

  describe "#take_bet" do
    context "initial bet" do
      it "should decrement the players balance" do
        expect { player.take_bet(10) }.to change { player.balance }.by(-10)
      end 
    end

    context "player raises bet" do
      it "should decrement the players balance" do
        player.take_bet(10)
        expect{ player.take_bet(20) }.to change { player.balance }.by(-10)
      end
    end

    context "if the bet is more than their balance" do
      it "raises an error" do
        expect { player.take_bet(1000) }.to raise_error "not enough money"
      end
    end

    it "should return the amount deducted" do
      expect(player.take_bet(10)).to eq(10)
    end
  end
end
