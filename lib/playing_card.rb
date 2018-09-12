class PlayingCard
  attr_reader :rank, :suit

  def initialize(rank:, suit:)
    @rank = rank
    @suit = suit
  end

  def inspect
    "#{@rank} of #{@suit}"
  end
end
