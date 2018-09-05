require_relative './playing_card'

class CardDeck
  def initialize
    @cards_left = []
    ranks = ['A', 'K', 'Q', 'J', '10', '9', '8', '7', '6', '5', '4', '3', '2']
    suits = ['Spades', 'Hearts', 'Clubs', 'Diamonds']
    ranks.each do |rank|
      suits.each do |suit|
        @cards_left.push(PlayingCard.new({:rank => rank, :suit => suit}))
      end
    end
  end

  def cardsLeft
    @cards_left.length
  end

  def shuffle
    @cards_left.shuffle!
  end

  def deal
    dealt_card = @cards_left.pop
  end
end
