require 'socket'
require_relative '../lib/war_socket_server'

class MockWarSocketClient
  attr_reader :socket
  attr_reader :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def accept_message(text)
    (text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    begin
      @output = @socket.read_nonblock(1000) # not gets which blocks
    rescue IO::WaitReadable
      @output = ""
    end
  end

  def close
    @socket.close if @socket
  end
end

def set_up_clients(int, server, clients, server_clients = [])
  int.times do
    clients.push(MockWarSocketClient.new(server.port_number))
    server_clients.push(server.accept_new_client)
  end
end

describe WarSocketServer do
  let(:clients) { [] }
  let(:server) { WarSocketServer.new }
  let(:game) { server.create_game_if_possible }

  context "before the server has started" do
    it "is not listening on a port"  do
      expect {MockWarSocketClient.new(server.port_number)}.to raise_error(Errno::ECONNREFUSED)
    end
  end

  context "after the server has started" do
    before(:each) do
      server.start
    end
    
    after(:each) do
      server.stop
      clients.each(&:close)
    end

    context "the initial game setup" do
      it "won't start a game with only 1 client" do
        set_up_clients(1, server, clients)
        server.create_game_if_possible
        expect(server.games.count).to be 0
      end
      
      it "starts a game when there are 2 clients" do
        set_up_clients(2, server, clients)
        server.create_game_if_possible
        expect(server.games.count).to be 1
      end
      
      it "sends a message to each client after they join" do
        set_up_clients(2, server, clients)
        clients.each { |client| expect(client.capture_output).to match /Welcome Random Player/ }
      end
    end
    
    context "during the game play" do
      it "returns a string that includes the cards left after each round" do
        set_up_clients(2, server, clients)
        clients.each { |client| client.provide_input('play') }
        server.run_game(game)
        clients.each { |client| expect(client.capture_output).to match /cards left/ }
      end
    end
  end
end
