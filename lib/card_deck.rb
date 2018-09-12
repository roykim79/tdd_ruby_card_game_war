require_relative './playing_card'

class CardDeck
  def initialize
    @cards_left = []
    ranks = %w[A K Q J 10 9 8 7 6 5 4 3 2]
    suits = %w[Spades Hearts Clubs Diamonds]
    ranks.each do |rank|
      suits.each do |suit|
        @cards_left.push(PlayingCard.new({rank: rank, suit: suit}))
      end
    end
  end

  def cards_left
    @cards_left.length
  end

  def shuffle
    @cards_left.shuffle!
  end

  def deal
    @cards_left.pop
  end
end
