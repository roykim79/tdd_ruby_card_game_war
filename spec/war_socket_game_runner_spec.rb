require 'rspec'
require 'war_game'
require 'war_socket_server'
require 'war_socket_game_runner'

def set_up_clients(int, server, clients, server_clients = [])
  int.times do
    clients.push(MockWarSocketClient.new(server.port_number))
    server_clients.push(server.accept_new_client)
  end
end

# TestClient = Struct.new(:mock_client, :server_client)

# def set_up_client(server)
#   TestClient.new(
#     MockWarSocketClient.new(server.port_number),
#     server.accept_new_client
#     )
# end

describe WarSocketGameRunner do
  let(:clients) { [] }
  let(:server_clients) { [] }
  let(:server) { WarSocketServer.new }
  let(:game) { server.create_game_if_possible }

  before :each do
    server.start
    set_up_clients(2, server, clients, server_clients)
    clients.each(&:capture_output)
    @socket_game_runner = WarSocketGameRunner.new(game, server_clients)
  end

  after :each do
    server.stop
    clients.each(&:close)
  end

  describe '#play_round_if_ready' do
    it 'will not return anything if only 1 player is ready' do
      clients[0].provide_input('play')
      @socket_game_runner.play_round_if_ready
      expect(clients[0].capture_output).not_to match(/cards/)
    end

    it 'will play a round and return the result if both players are ready' do
      clients.map { |client| client.provide_input('play') }
      @socket_game_runner.listen_to_clients
      @socket_game_runner.play_round_if_ready
      clients.each { |client| expect(client.capture_output).to match(/cards left/) }
    end
  end
end