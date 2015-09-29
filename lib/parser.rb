class Parser
  def self.call(client)
    method, path, version = client.gets.split(" ")

    env_hash = {}
    line = client.gets.strip!.split(": ")
    loop do
      break if line.empty?
      env_hash[line[0].upcase.gsub("-", "_")] = line[1]
      # require 'pry'; binding.pry
      line = client.gets.strip!.split(": ")
    end

    env_hash["REQUEST_METHOD"] = method
    env_hash["PATH_INFO"] = path
    env_hash["CONTENT_LENGTH"] = env_hash["CONTENT_LENGTH"].to_i
    env_hash
  end
end
