require 'stringio'
require 'socket'
require 'sinatra/base'

class NightWriterServer < Sinatra::Base
  def call
    # require 'pry'; binding.pry

  end

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
    # port       = 9294
    self.tcp_server = TCPServer.new(port)

    # Wait for a request
    client = tcp_server.accept

    # Read the request
    method, path, version = client.gets.split(" ")

    env_hash = {} # What you parse from the request

    line = client.gets.strip!.split(": ")
    until line.empty?
      env_hash[line[0]] = line[1]
      line = client.gets.strip!.split(": ")
    end
    env_hash["rack.input"] = StringIO.new
    env_hash["REQUEST_METHOD"] = method
    env_hash["PATH_INFO"] = path

    response = app.call(env_hash)

    # require 'pry'; binding.pry

    client.print("HTTP/1.1 #{response[0]} Found\r\n")
    client.print("Location: #{path}\r\n")
    client.print("Content-Type: text/html; charset=UTF-8\r\n")
    client.print("Content-Length: #{}\r\n")
    client.print("\r\n")
    client.print("<HTML><HEAD></HEAD><BODY>#{}</BODY>\r\n")
    client.close
  end

  def stop
    tcp_server.close_read
    tcp_server.close_write
  end
end

# go to http://localhost:9294/to_braille

# require your code you used for NightWriter
# note that we are talking to it through a web interface instead of a command-line interface
# hope you wrote it well enough to support that ;)
