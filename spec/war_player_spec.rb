require_relative '../lib/war_player'

describe 'WarPlayer' do
  before :each do
    @player = WarPlayer.new('Bob')
  end

  describe 'Initial player setup' do
    describe '#initialize' do
      it 'sets the players name' do
        expect(@player.name).to eq 'Bob'
      end
    end

    describe '#cards_left' do
      it 'is 0 before any cards have been dealt' do
        expect(@player.cards_left).to eq 0
      end
    end
  end

  describe 'Handling adding and removing cards from players hand' do
    before :each do
      @player.add_card(PlayingCard.new(rank: 'A', suit: 'Spades'))
    end

    describe '#add_card' do
      it 'adds a card to the players deck' do
        expect(@player.cards_left).to eq 1
      end
    end

    describe '#play_card' do
      it 'reduces the players cards left by 1' do
        @player.play_card
        expect(@player.cards_left).to eq 0
      end
    end

    describe '#take_cards' do
      it 'takes and array of cards and adds them to the players cards' do
        played_cards = [
          PlayingCard.new(rank: 'A', suit: 'Spades'),
          PlayingCard.new(rank: 'K', suit: 'Spades')
        ]
        @player.take_cards(played_cards)
        expect(@player.cards_left).to eq 3
      end
    end
  end
end
