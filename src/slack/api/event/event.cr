require "./event_type"

module Slack
  module Api
    class Event
      getter event_type : EventType
      getter event_channel : String
      getter event_user : String
      getter event_text : String
      getter event_t_stamp : String
      getter event_time : String

      def initialize(
        event_type : EventType,
        event_channel : String,
        event_user : String,
        event_text : String,
        event_t_stamp : String,
        event_time : String,
        event_channel_type : String
      )
        @event_type = event_type
        @event_channel = event_channel
        @event_user = event_user
        @event_text = event_text
        @event_t_stamp = event_t_stamp
        @event_time = event_time
        @event_channel_type = event_channel_type
      end
    end
  end
end
