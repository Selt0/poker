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
end