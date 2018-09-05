require_relative '../lib/war_game'

describe 'WarGame' do
  before :each do
    @game = WarGame.new()
    @game.start()
  end

  describe 'Initial game setup' do
    describe '#initialize' do
      it 'creates 2 instances of a WarPlayer' do
        expect(@game.player_1).to_not be_nil
        expect(@game.player_2).to_not be_nil
      end
    end

    describe '#start' do
      it 'should deal each player 26 cards' do
        expect(@game.player_1.cards_left).to eq(26)
        expect(@game.player_2.cards_left).to eq(26)
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

    describe '#get_hand_winner' do
      it 'returns the player with the higher of 2 cards' do
        card_1 = PlayingCard.new({:rank => 'A', :suit => 'Spades'})
        card_2 = PlayingCard.new({:rank => 'K', :suit => 'Spades'})
        expect(@game.get_hand_winner(card_1, card_2)).to eq(@game.player_1)
      end

      it 'returns nil when both players cards are the same value' do
        card_1 = PlayingCard.new({:rank => 'A', :suit => 'Spades'})
        card_2 = PlayingCard.new({:rank => 'A', :suit => 'Hearts'})
        expect(@game.get_hand_winner(card_1, card_2)).to eq(nil)
      end
    end

    describe '#play_round' do
      it 'changes each players cards remaining' do
        cards_player_1_started_with = @game.player_1.cards_left
        @game.play_round()
        expect(@game.player_1.cards_left).not_to eq(cards_player_1_started_with)
      end

      it 'returns a string of the outcome' do
        expect(@game.play_round).to be_instance_of(String)
      end

    end
  end



end
