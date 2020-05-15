class Player
  include Comparable

  attr_reader :balance, :hand, :current_bet

  def self.buy_in(starting_balance)
    Player.new(starting_balance)
  end

  def initialize(balance)
    @balance = balance
    @current_bet = 0
  end

  def deal_in(hand)
    @hand = hand
  end

  def take_bet(total_bet)
    amount = total_bet - @current_bet
    raise "not enough money" unless amount <=  @balance

    @current_bet = total_bet
    @balance -= amount
    amount
  end

  def reset_current_bet
    @current_bet = 0
  end

  def receive_winnings(winnings)
    @balance += winnings
  end

  def return_cards 
    cards = hand.cards
    @hand = nil
    cards
  end

  def fold
    @folded = true
  end

  def unfold
    @folded = false
  end

  def folded?
    @folded
  end

  def respond_bet
    print "(c)all, (b)et, or (f)old? > "
    response = gets.chomp.downcase[0]
    case response
    when 'c' then :call
    when 'b' then :bet
    when 'f' then :fold
    else
      puts "Enter 'c' for call, 'b' for bet, or 'f' for fold"
      respond_bet
    end
  end

  def get_bet
    print "Bet (bankroll: $#{balance}) > "
    bet = gets.chomp.to_i
    raise "not enough money" unless bet <= balance
    bet
  end

  def get_cards_to_trade
    print "Cards to trade? (ex. '1, 4, 5') > "
    card_indices = gets.chomp.split(', ').map(&:to_i)
    raise "cannot trade more than three cards" unless card_indices.count <= 3
    puts
    card_indices.map { |i| hand.cards[i - 1] }
  end

  def trade_cards(old_cards, new_cards)
    hand.trade_cards(old_cards, new_cards)
  end

  def <=>(other_player)
    hand
    other_player.hand
    hand <=> other_player.hand
  end
end