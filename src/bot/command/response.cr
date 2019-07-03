require "../../slack/api/post_message_request"
class Response

    def initialize(
                    text : String,
                    channel : String,
                    bot : Bot,
                    timestamp : String
        )
        @response_text = text
        @channel = channel
        @bot = bot
        @timestamp = timestamp
    end

    def post!
        Slack::Api::PostMessageRequest.new(
            channel: @channel, 
            text: @response_text,
            bot_token: @bot.token, 
            t_stamp: @timestamp
        ).perform!
    end
end