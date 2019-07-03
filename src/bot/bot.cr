require "json"
require "../slack/api/auth_test_request"


class Bot
  getter id : String
  getter token : String
  getter name : String

  def initialize(bot_api_token : String, name : String = "")
    @token = bot_api_token
    @name = parse_auth_data["user"].as_s
    @id = parse_auth_data["user_id"].as_s
    @auth_data = uninitialized JSON::Any
  end

  private def parse_auth_data : JSON::Any
    response = Slack::Api::AuthTestRequest.new(@token).perform!
    json_body = JSON.parse(response.body)
    return json_body["ok"] == true ? json_body : JSON.parse("{\"user\":\"BOT\", \"user_id\":\"NOID\"}")
  end
end
