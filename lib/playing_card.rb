class PlayingCard
  attr_reader :rank, :suit

  def initialize(attributes)
    @rank = attributes.fetch(:rank)
    @suit = attributes.fetch(:suit)
  end

  def inspect
    "#{@rank} of #{@suit}"
  end
end
