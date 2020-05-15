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
    let(:hand) { double('hand') }

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

  describe "#receive_winnings" do 
    it "should increment the players balance by the amount won" do
      expect { player.receive_winnings(10) }.to change { player.balance }.by(10)
    end
  end

  describe "#return_cards" do
    let(:hand) { double('hand') }
    let(:cards) { double('cards') }

    before(:each) do
      player.deal_in(hand)
      allow(hand).to receive(:cards).and_return(cards)
    end

    it "should return the players cards" do
      expect(player.return_cards).to eq(cards)
    end

    it "should set the players hand to nill" do
      player.return_cards
      expect(player.hand).to be(nil)
    end
  end

  describe "#fold" do
    it "should set #folded? to true" do
      player.fold
      expect(player).to be_folded
    end
  end

  describe "#unfold" do
    it "should set #folded? to false" do
      player.unfold
      expect(player).to_not be_folded
    end
  end

  describe '#folded?' do
    let(:player) { Player.new(1000) }

    it "should return true if player is folded" do
      player.fold
      expect(player).to be_folded
    end

    it "should return false otherwise" do
      expect(player).to_not be_folded
    end
  end
end
