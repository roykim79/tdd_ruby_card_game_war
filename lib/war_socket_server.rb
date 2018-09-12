require 'socket'
require_relative 'war_game'
require_relative 'war_client'
require_relative 'war_socket_game_runner'

class WarSocketServer
  def initialize
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

  def accept_new_client(player_name = 'Random Player')
    client = WarClient.new(@server.accept_nonblock, player_name)
    pending_clients.push(client)
    client.connection.puts(pending_clients.count.odd? ? "Welcome #{player_name}. Waiting for another player to join." : "Welcome #{player_name}. You are about to go to war.")
    puts "#{player_name} has joined"
    client
  rescue IO::WaitReadable, Errno::EINTR
    puts 'No client to accept'
  end

  def create_game_if_possible
    if pending_clients.count > 1
      game = WarGame.new
      games.push(game)
      games_to_humans[game] = pending_clients.shift(2)
      game.start
      game
    end
  end

  def run_game(game)
    Thread.start do
      game_runner = WarSocketGameRunner.new(game, games_to_humans[game])
      game_runner.start
    end
  end

  def stop
    @server.close if @server
  end

  private

  def pending_clients
    @pending_clients ||= []
  end

  def games_to_humans
    @games_to_humans ||= {}
  end

  def players
    @players ||= {}
  end
end
