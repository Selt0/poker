require_relative 'deck'
require_relative 'player'

class Game

  attr_reader :pot, :deck, :players

  def initialize
    @deck = Deck.new
    @pot = 0
    @players = []
  end

  def play
    play_round until game_over?
    end_game
  end

  def play_round
    deck.shuffle
    reset_players
    deal_cards
    take_bets
    trade_cards
    take_bets
    end_round
  end

  def reset_players
    players.each(&:unfold)
  end

  def deal_cards
    players.each do |player|
      next if player.balance <= 0
      player.deal_in(deck.deal_hand)
    end
  end

  def take_bets
    players.each(&:reset_current_bet)
    high_bet = 0
    no_raises = false
    most_recent_better = nil

    until no_raises
      no_raises = true
      players.each_with_index do |player, i|
        next if player.folded?
        break if most_recent_better == player || round_over?
        system "clear"
        display_status(i, high_bet)
        begin
          response = player.respond_bet
          case response
          when :call then add_to_pot(player.take_bet(high_bet))
          when :bet
            raise "not enough money" unless player.balance >= high_bet
            no_raises = false
            most_recent_better = player
            bet = player.get_bet
            raise "bet must be at least $#{high_bet}" unless bet >= high_bet
            rs = player.take_bet(bet)
            high_bet = bet
            add_to_pot(rs)
          when :fold then player.fold
          end
        rescue => exception
          puts "#{error.message}"
          retry
        end
      end
    end
  end

  def display_status(index, high_bet)
    puts "Pot: $#{@pot}"
    puts "High bet: $#{high_bet}"

    players.each_with_index { |player, i| puts "Player #{i + 1} has $#{player.balance}" }

    puts
    puts "Current player: #{index + 1}"
    puts "Player #{index + 1} has bet: $#{players[index].current_bet}"
    puts "The bet is at $#{high_bet}"
    puts "Player #{index + 1}'s hand: #{players[index].hand}"
  end

  def trade_cards
    players.each_with_index do |player, i|
      next if player.folded?
      print "Player #{i + 1}, which cards do you want to trade: "
      puts player.hand
      cards = player.get_cards_to_trade
      deck.return(cards)
      player.trade_cards(cards, deck.take(cards.count))
    end
  end

  def end_round 
    show_hands
    puts
    puts "WINNER"
    puts "#{winner.hand} wins $#{pot} with a #{winner.hand.rank}"
    winner.receive_winnings(pot)
    @pot = 0
    return_cards
  end

  def return_cards
    players.each { |player| @deck.return(player.return_cards) }
  end

  def winner
    players.max
  end

  def show_hands
    puts "HANDS"
    players.each do |player|
      next if player.folded?
      puts "#{player.hand} (#{player.hand.rank})"
    end
  end

  def add_to_pot(amount)
    (@pot += amount) && amount
  end

  def round_over?
    players.count { |player| !player.folded? } <= 1
  end

  def game_over?
    players.count { |player| player.balance > 0 } <= 1
  end

  def add_players(n, buy_in)
    n.times  { @players << Player.buy_in(buy_in) }
  end

  def end_game
    puts "The game is over"
  end
end

def test
  game = Game.new
  game.add_players(5, 100)
  game.play
end

if __FILE__ == $PROGRAM_NAME
  test
end