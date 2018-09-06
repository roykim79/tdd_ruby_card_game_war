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

  def capture_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
  end
end

describe WarSocketServer do
  before :each do
    @clients = []
    @server = WarSocketServer.new
  end

  context "the initial state of the server" do
    it "is not listening on a port before it is started"  do
      expect {MockWarSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
    end
  end

  context 'the initial game setup' do
    let(:client1) { MockWarSocketClient.new(@server.port_number) }
    let(:client2) { MockWarSocketClient.new(@server.port_number) }

    before(:each) do
      @server.start
      @clients.push(client1)
      @server.accept_new_client("Player 1")
      @server.create_game_if_possible
    end

    after(:each) do
      @server.stop
      @clients.each do |client|
        client.close
      end
    end

    it "accepts new clients and starts a game if possible" do
      expect(@server.games.count).to be 0
      @clients.push(client2)
      @server.accept_new_client("Player 2")
      @server.create_game_if_possible
      expect(@server.games.count).to be 1
    end

    # Add more tests to make sure the game is being played
    # For example:
    #   make sure the mock client gets appropriate output
    #   make sure the next round isn't played until both clients say they are ready to play
    #   ...
    it "sends a message to the client once they join" do
      expect(client1.capture_output).to match /Welcome Player 1. Waiting for another player to join./
      @clients.push(client2)
      @server.accept_new_client("Player 2")
      expect(client2.capture_output).to match /Welcome Player 2. You are about to go to war./
    end
  end

  context "the game play" do
    let(:client1) { MockWarSocketClient.new(@server.port_number) }
    let(:client2) { MockWarSocketClient.new(@server.port_number) }

    before(:each) do
      @server.start
      @clients.push(client1)
      @server.accept_new_client("Player 1")
      client1.capture_output
      @server.create_game_if_possible
      @clients.push(client2)
      @server.accept_new_client("Player 2")
      client2.capture_output
      @server.create_game_if_possible
    end

    after(:each) do
      @server.stop
      @clients.each do |client|
        client.close
      end
    end

    describe '#inform_players_of_hand' do
      it "tells each player how many cards they have left" do
        @clients.each do |client|
          expect(client.capture_output).to match /You have 26 cards left/
        end
      end
    end

    it "wait for the players to say they are ready before playing a round" do

    end
  end





end
