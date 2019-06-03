require "http/client"

module Slack
    module Api
        class PostMessageRequest
            
            def initialize(channel : String, api_token : String, text : String, t_stamp : String = "0")
                @channel = channel
                @api_token = api_token
                @text = text
                @request_body = JSON.parse("{\"ok\":\"false\"}")
                @t_stamp = t_stamp
            end

            def response
                response = HTTP::Client.post(
                    "https://slack.com/api/chat.postMessage", 
                    headers: HTTP::Headers{
                        "Content-Type" => "application/json",
                        "Authorization" => "Bearer #{@api_token}"
                    }, 
                    form: {"channel" => @channel, "thread_ts" => @t_stamp,"text" => @text, "as_user" => "true"}
                )
            end
        end
    end
end
