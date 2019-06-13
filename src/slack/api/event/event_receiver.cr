require "kemal"
require "json"

post "/" do |env|
  challenge = env.params.json["challenge"].as(String)
  env.response.content_type = "application/json"
  {"challenge": challenge}.to_json
end

def run_server 
    Kemal.run
end
