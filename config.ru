class LetsGoExploring
  def call(hash)
    status_code = 200
    headers     = {'Content-Type' => 'text/html;', 'Content-Length' => '15'}
    body        = ["<h1>Hello!</h1>"]

    require "pry"
    binding.pry

    [status_code, headers, body]
  end
end
run
