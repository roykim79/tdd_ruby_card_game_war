require 'socket'

class WarSocketServer
  attr_reader :games, :players

  def initialize
    # @players = []
  end

  def port_number
    3336
  end

  def games
    @games ||= []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    pending_clients.push(client)
    # associate player and client
    client.puts(pending_clients.count.odd? ? "Welcome #{player_name}. Waiting for another player to join." : "Welcome #{player_name}. You are about to go to war.")

  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    if pending_clients.count > 1
      game = WarGame.new()
      games.push(game)
      games_to_humans[game] = pending_clients.shift(2)
      game.start
      inform_players_of_hand(game)
    end
  end

  def stop
    @server.close if @server
  end

  def pending_clients
    @pending_clients ||= []
  end

  def games_to_humans
    @games_to_humans ||= {}
  end

  def inform_players_of_hand(game)
    humans = games_to_humans[game]
    humans[0].puts("You have #{game.player_1.cards_left} cards left")
    humans[1].puts("You have #{game.player_2.cards_left} cards left")
  end
end
