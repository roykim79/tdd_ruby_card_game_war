class WarClient
  attr_reader :connection, :name
  attr_accessor :ready

  def initialize(connection, name)
    @connection = connection
    @name = name
    @ready = false
  end
end
