require "./event_type"
require "../exception/*"
require "../../../app"

module Slack
  module Api
    class EventParser
      def initialize(input : JSON::Any)
        @input = input
      end

      def to_event : Event
        begin
          event_type = event_type_enum(@input["event"]["channel_type"].as_s)
          event = Event.new(
            event_type: event_type,
            event_channel: @input["event"]["channel"].as_s,
            event_user: @input["event"]["user"].as_s,
            event_text: @input["event"]["text"].as_s,
            event_t_stamp: @input["event"]["ts"].as_s,
            event_time: @input["event"]["event_ts"].as_s,
            event_channel_type: @input["event"]["channel_type"].as_s,
          )
          App.singleton.logger.debug("event parsed: #{@input["event"]}")
          return event
        rescue err: KeyError
          App.singleton.logger.error(err.message)
          raise InvalidJsonException.new("json invalid")
        end
      end

      private def event_type_enum(event_type : String) : EventType | Nil
        EventType.parse?(event_type.upcase) || EventType::UNKNOWN
      end
    end
  end
end
