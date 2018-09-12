require_relative '../lib/playing_card'

describe 'PlayingCard' do
  before :each do
    @card = PlayingCard.new(rank: 'A', suit: 'Spades')
  end

  describe 'rank' do
    it 'returns the rank of the card' do
      expect(@card.rank).to eq 'A'
      expect(@card.rank).not_to eq 'J'
    end
  end

  describe 'suit' do
    it 'returns the suit of a playing card' do
      expect(@card.suit).to eq 'Spades'
    end
  end
end
