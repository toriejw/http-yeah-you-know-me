require 'stringio'
require 'socket'
require 'sinatra/base'
require 'pry'
require_relative './parser'

class NightWriterServer < Sinatra::Base
  get '/to_braille' do
    "<form action='/to_braille' method='post'>
      <input type='textarea' name='english-message'></input>
      <input type='Submit'></input>
    </form>"
  end

  post '/to_braille' do
    message = params['english-message'].split(" ")
    braille = Translator.night_write(message)
    "<pre>#{braille}</pre>"
  end
end

class HttpYeahYouKnowMe
  attr_reader :port, :app
  attr_accessor :tcp_server

  def initialize(port, app)
    @port = port
    @app = app
    @tcp_server
  end

  def start
    self.tcp_server = TCPServer.new(port)
    loop do
      client = tcp_server.accept
      env_hash = Parser.call(client)
      env_hash["rack.input"] = StringIO.new client.read(env_hash["CONTENT_LENGTH"])
      response = app.call(env_hash)
      create_response(client, response)
      client.close
    end
  end

  def stop
    tcp_server.close_read
    tcp_server.close_write
  end

  private
  def create_response(client, response)
    headers = response[1]

    client.print("HTTP/1.1 #{response[0]} Found\r\n")
    headers.each { |key, value| client.print("#{key}: #{value}\r\n")}
    client.print("\r\n")
    # binding.pry
    body = response[2][0]
    # binding.pry
    client.print("#{body}")
  end
end
