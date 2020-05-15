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
end