require 'stringio'

class HttpYeahYouKnowMe
  def initialize(port, app)

  end

  # def start
  # end
  #
  # def stop
  #
  # end


end

# go to http://localhost:9294/to_braille

# require your code you used for NightWriter
# note that we are talking to it through a web interface instead of a command-line interface
# hope you wrote it well enough to support that ;)
require_relative '../../night-writer/lib/night_write'

# require a webserver named Sinatra
require 'sinatra/base'

class NightWriterServer < Sinatra::Base
  get '/to_braille' do
    "<form action='/to_braille' method='post'>
      <input type='textarea' name='english-message'></input>
      <input type='Submit'></input>
    </form>"
  end

  post '/to_braille' do
    message = params['english-message'].split(" ")
    braille = NightWrite.new(message).call # <-- change this to look like your night writer code
    "<pre>#{braille}</pre>"
  end
end


# switch this to use your server
use_my_server = false

if use_my_server
  require_relative 'lib/http_yeah_you_know_me' # <-- probably right, but double check it
  server = HttpYeahYouKnowMe.new(9294, NightWriterServer)
  at_exit { server.stop }
  server.start
else
  NightWriterServer.set :port, 9294
  NightWriterServer.run!
end


# You for sure need these keys:
{"REQUEST_METHOD" => "GET", "PATH_INFO" => "/users/456", "rack.input" => StringIO.new}

# You'll need to pass this through to the TCPServer
port = 9294

# The app:
#   You're serving the code, the app is responsible for deciding what to do with the request.
#   An app is any object that has a method named `call`
#   that can receive a the hash you parsed from the request
#   and return an array with these three things in it
app = lambda do |env_hash|
  [302, {'Location' => 'http://turing.io'}, ["<h1>hi</h1>"]]
end

# For clarity:
env_hash = {} # What you parse from the request
app.call(env_hash) # => [200, {"Content-Type"=>"text/plain", "Content-Length"=>"5"}, ["hello"]]

# Your server takes the port and the app, starts up when we call start, closes the read / write when we call stop
server = HttpYeahYouKnowMe.new(port, app)
server.start # this will lock the computer up as it waits for the request to come in
server.stop
