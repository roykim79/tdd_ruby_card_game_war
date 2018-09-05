require_relative 'war_player'
require_relative 'card_deck'
require_relative 'playing_card'

class WarGame
  attr_reader :player_1, :player_2
  attr_accessor :tabled_cards
  VALUES = {
    '2' => 1,
    '3' => 2,
    '4' => 3,
    '5' => 4,
    '6' => 5,
    '7' => 6,
    '8' => 7,
    '9' => 8,
    '10' => 9,
    'J' => 10,
    'Q' => 11,
    'K' => 12,
    'A' => 13
  }

  def initialize()
    @player_1 = WarPlayer.new('Player 1')
    @player_2 = WarPlayer.new('Player 2')
    @tabled_cards = []
  end

  def start
    deck = CardDeck.new()
    deck.shuffle()
    until deck.cardsLeft <= 0 do
      player_1.add_card(deck.deal)
      player_2.add_card(deck.deal)
    end
  end

  def get_hand_winner(player_1_card, player_2_card)
    if VALUES[player_1_card.rank] > VALUES[player_2_card.rank]
      player_1
    elsif VALUES[player_2_card.rank] > VALUES[player_1_card.rank]
      player_2
    else
      nil
    end
  end

  def play_round
    player_1_card = player_1.play_card
    player_2_card = player_2.play_card
    tabled_cards.push(player_1_card)
    tabled_cards.push(player_2_card)
    display_string = ""
    hand_winner = get_hand_winner(player_1_card, player_2_card)
    if hand_winner
      display_string << "#{hand_winner.name} takes "
      tabled_cards.size.times do
        card = tabled_cards.pop
        display_string << "#{card.inspect}, "
        hand_winner.add_card(card)
      end
    else
      display_string = "It's a tie"
    end
    display_string
  end

  def winner
    if player_1.cards_left <= 0
      player_2
    elsif player_2.cards_left <= 0
      player_1
    else
      false
    end
  end
end
