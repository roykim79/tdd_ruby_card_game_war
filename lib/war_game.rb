require_relative 'war_player'
require_relative 'card_deck'
require_relative 'playing_card'

class WarGame
  attr_reader :player1, :player2
  attr_accessor :played_cards

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
  }.freeze

  def initialize(player1 = WarPlayer.new('Player 1'), player2 = WarPlayer.new('Player 2'))
    @player1 = player1
    @player2 = player2
    @played_cards = []
  end

  def start
    deck = CardDeck.new
    deck.shuffle
    while deck.cards_left > 0
      player1.add_card(deck.deal)
      player2.add_card(deck.deal)
    end
  end

  def get_round_winner(player1_card, player2_card)
    if VALUES[player1_card.rank] > VALUES[player2_card.rank]
      player1
    elsif VALUES[player2_card.rank] > VALUES[player1_card.rank]
      player2
    end
  end

  def play_round
    round_winner = get_round_winner(player1.play_card, player2.play_card)
    played_cards.push(player1.play_card, player2.play_card)
    result_string = handle_result_string(round_winner, played_cards)
    round_winner.take_cards(played_cards) if round_winner
    result_string
  end

  def winner
    if player1.cards_left <= 0
      player2
    elsif player2.cards_left <= 0
      player1
    else
      false
    end
  end

  private

  def handle_result_string(winner, cards)
    if winner
      result_string = "#{winner.name} takes "
      cards.each { |card| result_string << "#{card.inspect}, " }
      result_string
    else
      "It's a tie, "
    end
  end
end
