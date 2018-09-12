
class WarPlayer
  attr_reader :name, :cards

  def initialize(name, client = nil)
    @name = name
    @cards = []
    @client = client
  end

  def add_card(card)
    cards.push(card)
  end

  def cards_left
    cards.length
  end

  def take_cards(array_of_cards)
    @cards += array_of_cards
  end

  def play_card
    cards.shift
  end
end
