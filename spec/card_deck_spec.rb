require_relative '../lib/card_deck'

describe 'CardDeck' do
  before :each do
    @deck = CardDeck.new()
  end

  describe '#initialize' do
    it 'should have 52 cards when created' do
      expect(@deck.cardsLeft).to eq 52
    end
  end

  describe '#deal' do
    it 'should deal the top card' do
      card = @deck.deal
      expect(card).to_not be_nil
      expect(@deck.cardsLeft).to eq 51
    end

    it 'returns a card with a value between 2 - 10 or A, K, Q, J' do
      values = ['A', 'K', 'Q', 'J', '10', '9', '8', '7', '6', '5', '4', '3', '2']
      card = @deck.deal
      expect(values.include?(card.rank)).to eq true
    end

    it 'returns a card with a suit that is either Spades, Hearts, Clubs or Diamonds' do
      suits = ['Spades', 'Hearts', 'Clubs', 'Diamonds']
      card = @deck.deal
      expect(suits.include?(card.suit)).to eq true
    end
  end

  describe '#shuffle' do
    it 'randomly reorders the cards' do
      deck2 = CardDeck.new()
      deck2.shuffle()
      card1 = @deck.deal
      card2 = deck2.deal
      expect(card1.inspect).not_to eq(card2.inspect)
    end
  end
end
