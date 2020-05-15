require 'rspec'
require 'game'

describe Game do
  subject(:game) { Game.new }

  describe "#initialize" do
    it "should set up an empty pot" do
      expect(game.pot).to eq(0)
    end
  end

  describe "#deck" do
    it "should start with a deck" do
      expect(game.deck).to be_a(Deck)
    end

    it "should start with a full deck" do
      expect(game.deck.count).to eq(52)
    end
  end

  describe "#add_players" do
    it "should create the specified number of players" do
      game.add_players(2, 100)
      expect(game.players.length).to eq(2)
    end

    it "should create players" do
      game.add_players(3, 100)
      expect(game.players.first).to be_a(Players)
    end

    it "should set the players bankrolls" do
      game.add_players(3, 100)
      expect(game.players.all? { |player| player.balance == 100 }).to be(true)
    end
  end

  describe "#game_over?" do
    context "When players still have money" do
      it "should return false" do
        game.add_players(5, 100)
        expect(game).not_to be_game_over
      end
    end

    context "When all but one player has no more money" do
      it "should return true" do
        game.add_players(5, 0)
        game.add_players(1, 100)
        expect(game).to be_game_over
      end
    end
  end

  describe '#deal_cards' do
    before(:each) { game.add_players(5, 100) }
    
    it "should give each player a full hand" do
      game.deal_cards
      expect (game.players.all? { |player| player.hand }).to be(true)
    end

    context "when the player has no money" do
      it "should not give a player a hand" do
        game.add_players(1, 0)
        game.deal_cards
        expect(game.players.last.hand).to be_nil
      end
    end
  end

  describe "#add_to_pot" do
    it "should add the specified amount to the pot" do
      expect { game.add_to_pot(100) }.to change { game.pot }.by(100)
    end

    it "should return the amount added" do
      expect(game.add_to_pot(100)).to eq(100)
    end
  end
end