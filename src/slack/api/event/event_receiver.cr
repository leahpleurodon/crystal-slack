require "kemal"
require "json"
require "../../../**"

post "/" do |env|
  env.response.content_type = "application/json"
  env.params.json.has_key?("challenge") ? verify_auth(env.params.json["challenge"].as(String)) : handle_event_and_return_ok(JSON.parse(env.params.json.to_json))
end

private def verify_auth(challenge_token : String)
  App.singleton.logger.info("slack api verifying auth")
  {"challenge": challenge_token}.to_json
end

private def handle_event_and_return_ok(json : JSON::Any)
  begin
    App.singleton.logger.info("event received")
    event = Slack::Api::EventParser.new(json).to_event
    App.singleton.set_event(event)
    command = EventCommandMatcher.find_command_match(App.singleton, event)
    command.call(event) if command
    return {"ok": "true"}.to_json
  rescue e
    App.singleton.logger.error(e.message)
    return {"ok": "false", "message": e.message}.to_json
  end
end

def run_server
  Kemal.run
end
