require_relative '../lib/war_game'

describe 'WarGame' do
  before :each do
    @game = WarGame.new
    @game.start
  end

  describe 'Initial game setup' do
    describe '#initialize' do
      it 'creates 2 instances of a WarPlayer' do
        expect(@game.player1).to_not be_nil
        expect(@game.player2).to_not be_nil
      end
    end

    describe '#start' do
      it 'should deal each player 26 cards' do
        expect(@game.player1.cards_left).to eq(26)
        expect(@game.player2.cards_left).to eq(26)
      end
    end
  end

  describe 'Game play' do
    before :each do
      @game.start
    end

    describe '#winner' do
      it 'will return false at the start of the game' do
        expect(@game.winner).to eq false
      end
    end

    describe '#get_round_winner' do
      it 'returns the player with the higher of 2 cards' do
        card1 = PlayingCard.new(rank: 'A', suit: 'Spades')
        card2 = PlayingCard.new(rank: 'K', suit: 'Spades')
        expect(@game.get_round_winner(card1, card2)).to eq(@game.player1)
      end

      it 'returns nil when both players cards are the same value' do
        card1 = PlayingCard.new(rank: 'A', suit: 'Spades')
        card2 = PlayingCard.new(rank: 'A', suit: 'Hearts')
        expect(@game.get_round_winner(card1, card2)).to eq(nil)
      end
    end

    describe '#play_round' do
      it 'changes each players cards remaining' do
        cards_player1_started_with = @game.player1.cards_left
        @game.play_round
        expect(@game.player1.cards_left).not_to eq(cards_player1_started_with)
      end

      it 'returns a string of the outcome' do
        expect(@game.play_round).to be_instance_of(String)
      end
    end
  end
end
