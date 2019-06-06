require "./command/command"
require "json"
require "../slack/api/auth_test_request"

module Bot
    class Bot
        
        getter id : String
        getter name : String

        def initialize(name : String = "")
            @token = ENV["SLACK_BOT_TOKEN"]
            @name = parse_auth_data["user"].as_s
            @commands = [] of Command
            @id = parse_auth_data["user_id"].as_s
            @auth_data = uninitialized JSON::Any
        end


        private def parse_auth_data : JSON::Any
            response = Slack::Api::AuthTestRequest.new(@token).perform!
            json_body = JSON.parse(response.body)
            return json_body["ok"] == true ? json_body : JSON.parse("{\"user\":\"BOT\", \"user_id\":\"NOID\"}")
        end
    end
end