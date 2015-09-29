require '/Users/Torie/Documents/turing/module_1/projects/night-writer/lib/translator'
require_relative 'lib/http_yeah_you_know_me'
require 'sinatra/base'

class NightWriterServer < Sinatra::Base
  get '/to_braille' do
    "<form action='/to_braille' method='post'>
      <input type='textarea' name='english-message'></input>
      <input type='Submit'></input>
    </form>"
  end

  # post '/to_braille' do
  #   message = params['english-message'].split(" ")
  #   braille = NightWrite.new(message).call
  #   "<pre>#{braille}</pre>"
  # end
end


# switch this to use your server
use_my_server = true

if use_my_server
  # require_relative './lib/http_yeah_you_know_me' # <-- probably right, but double check it
  server = HttpYeahYouKnowMe.new(9294, NightWriterServer)
  at_exit { server.stop }
  server.start
else
  NightWriterServer.set :port, 9294
  NightWriterServer.run!
end
