class WarSocketGameRunner
  attr_reader :game, :clients

  def initialize(game, clients)
    @game = game
    @clients = clients
  end

  def start
    until game.winner
      listen_to_clients
      play_round_if_ready
    end
    puts(game.winner)
  end

  def listen_to_clients
    clients.each do |client|
      client_input = read_connection(client)
      client.ready = true if /play/ =~ client_input
    end
  end

  def play_round_if_ready
    return unless clients.all?(&:ready)

    round_result = game.play_round
    inform_players(round_result)
    clients.each { |client| client.ready = false }
  end

  private

  def read_connection(client)
    client.connection.read_nonblock(1000)
  rescue IO::WaitReadable
    ''
  end

  def inform_players(round_result)
    clients[0].connection.puts("#{round_result}you have #{game.player1.cards_left} cards left")
    clients[1].connection.puts("#{round_result}you have #{game.player2.cards_left} cards left")
  end
end
