
class WarPlayer
  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end

  def add_card(card)
    @cards.push(card)
  end

  def cards_left
    @cards.length
  end

  def play_card
    @cards.shift
  end
end
