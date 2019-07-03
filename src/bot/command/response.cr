require "../../slack/api/event/event"
require "../../slack/api/post_message_request"
class Response

    def initialize(
                    event : Slack::Api::Event, 
                    text : String,
                    channel : String,
                    bot : Bot,
                    timestamp : String
        )
        @event = event
        @response_text = text
        @channel = channel
        @bot = bot
        @timestamp = timestamp
    end

    def post!
        Slack::Api::PostMessageRequest.new(
            channel: @channel, 
            text: parse_magic_fields,
            bot_token: @bot.token, 
            t_stamp: @timestamp
        ).perform!
    end

    private def parse_magic_fields : String
        parsed_response = @response_text
        self.matches.keys.each do |key|
            parsed_response = parsed_response.gsub(key, matches[key])
        end
        return parsed_response
    end

    private def matches : Hash(String, String)
        return {
            "<!user!>" => "<@#{@event.event_user}>",
            "<!channel!>" => @event.event_channel,
            "<!timestamp!>" => @event.event_t_stamp,
            "<!text!>" => @event.event_text,
            "<!time!>" => @event.event_time
        }
    end
end