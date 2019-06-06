require "http/client"
require "../../bot/bot"

module Slack
    module Api
        class AuthTestRequest
            
            def initialize(token : String)
                @token = token
            end

            def perform!
                response = HTTP::Client.get(
                    "https://slack.com/api/auth.test?token=#{@token}"
                )
            end
        end
    end
end
