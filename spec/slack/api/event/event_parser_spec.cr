require "../../../spec_helper"
require "../../../../src/slack/api/event/**"
require "../../../../src/slack/api/exception/*"
require "json"

module Slack
  module Api
    describe Slack::Api::EventParser do
      describe "#to_event" do
        it "Returns the CHANNEL event type enum val in the hash" do
          input = "{
                        \"token\": \"one-long-verification-token\",
                        \"team_id\": \"T061EG9R6\",
                        \"api_app_id\": \"A0PNCHHK2\",
                        \"event\": {
                            \"type\": \"message\",
                            \"channel\": \"C024BE91L\",
                            \"user\": \"U2147483697\",
                            \"text\": \"Live long and prospect.\",
                            \"ts\": \"1355517523.000005\",
                            \"event_ts\": \"1355517523.000005\",
                            \"channel_type\": \"channel\"
                        },
                        \"type\": \"event_callback\",
                        \"authed_teams\": [
                            \"T061EG9R6\"
                        ],
                        \"event_id\": \"Ev0PV52K21\",
                        \"event_time\": \"1355517523\"
                    }"

          event = Slack::Api::EventParser.new(JSON.parse(input)).to_event

          event.event_type.should eq(EventType::CHANNEL)
        end

        it "Returns the MPIM event type enum val in the hash" do
          input = "{
                        \"token\": \"one-long-verification-token\",
                        \"team_id\": \"T061EG9R6\",
                        \"api_app_id\": \"A0PNCHHK2\",
                        \"event\": {
                            \"type\": \"message\",
                            \"channel\": \"G024BE91L\",
                            \"user\": \"U2147483697\",
                            \"text\": \"Let's make a pact.\",
                            \"ts\": \"1355517523.000005\",
                            \"event_ts\": \"1355517523.000005\",
                            \"channel_type\": \"mpim\"
                        },
                        \"type\": \"event_callback\",
                        \"authed_teams\": [
                            \"T061EG9R6\"
                        ],
                        \"event_id\": \"Ev0PV52K21\",
                        \"event_time\": 1355517523
                    }"

          event = Slack::Api::EventParser.new(JSON.parse(input)).to_event

          event.event_type.should eq(EventType::MPIM)
        end

        it "Raises an invalid Json Exception if the channel/event type is invalid" do
          input = "{
                        \"token\": \"one-long-verification-token\",
                        \"team_id\": \"T061EG9R6\",
                        \"api_app_id\": \"A0PNCHHK2\",
                        \"event\": {
                            \"type\": \"message\",
                            \"channel\": \"C024BE91L\",
                            \"user\": \"U2147483697\",
                            \"text\": \"Live long and prospect.\",
                            \"ts\": \"1355517523.000005\",
                            \"event_ts\": \"1355517523.000005\",
                            \"channel_type\": \"an unsupported channel type\"
                        },
                        \"type\": \"event_callback\",
                        \"authed_teams\": [
                            \"T061EG9R6\"
                        ],
                        \"event_id\": \"Ev0PV52K21\",
                        \"event_time\": \"1355517523\"
                    }"
          expect_raises(InvalidJsonException, "json invalid") do
            Slack::Api::EventParser.new(JSON.parse(input)).to_event
          end
        end

        it "Raises an invalid Json Exception if there is no data" do
          input = "{}"
          expect_raises(InvalidJsonException, "json invalid") do
            Slack::Api::EventParser.new(JSON.parse(input)).to_event
          end
        end

        it "Raises an invalid Json Exception is any event data is missing" do
          # \"user\": \"U2147483697\", taken out of the event section
          input = "{
                        \"token\": \"one-long-verification-token\",
                        \"team_id\": \"T061EG9R6\",
                        \"api_app_id\": \"A0PNCHHK2\",
                        \"event\": {
                            \"type\": \"message\",
                            \"channel\": \"C024BE91L\",
                            \"text\": \"Live long and prospect.\",
                            \"ts\": \"1355517523.000005\",
                            \"event_ts\": \"1355517523.000005\",
                            \"channel_type\": \"an unsupported channel type\"
                        },
                        \"type\": \"event_callback\",
                        \"authed_teams\": [
                            \"T061EG9R6\"
                        ],
                        \"event_id\": \"Ev0PV52K21\",
                        \"event_time\": \"1355517523\"
                    }"
          expect_raises(InvalidJsonException, "json invalid") do
            Slack::Api::EventParser.new(JSON.parse(input)).to_event
          end
        end
      end
    end
  end
end
