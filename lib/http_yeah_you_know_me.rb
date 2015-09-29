require 'stringio'
require 'socket'
require 'sinatra/base'
require 'pry'

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
      method, path, version = client.gets.split(" ")

      env_hash = {}
      line = client.gets.strip!.split(": ")
      until line.empty?
        env_hash[line[0]] = line[1]
        line = client.gets.strip!.split(": ")
      end

      env_hash["rack.input"] = StringIO.new
      env_hash["REQUEST_METHOD"] = method
      env_hash["PATH_INFO"] = path

      response = app.call(env_hash)

      headers = response[1]

      client.print("HTTP/1.1 #{response[0]} Found\r\n")
      headers.each { |key, value| client.print("#{key}: #{value}\r\n")}
      client.print("\r\n")

      if response[2].first.nil?
        client.print("#{}\r\n")
      else
        body = StringIO.new response[2][0]
        client.print("#{body.read(env_hash["Content-Length"])}\r\n")
      end

      client.close
    end
  end

  def stop
    tcp_server.close_read
    tcp_server.close_write
  end
end
