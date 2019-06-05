require "../../spec_helper"
require "../../../src/bot/command/**"
require "../../../src/slack/api/*"

module Bot
    describe "#match?" do
        it "matches regex for HEAR command type without bot name" do
            string_to_match = "whats the weather like in Brussels?"
            command = Command.new(
                Bot.new("token", "bot mc-botface"),
                Slack::Api::PostMessageRequest.new(
                    "12345",
                    "ABC-123-DEF-456",
                    "tra la la la la"
                ),
                CommandType::HEAR,
                "what'*s the weather like in (\\w+)\\?*"
            )

            command.matches?(string_to_match).should be_true
        end

        it "doesn't match regex for HEAR command type without bot name" do
            string_to_match = "hows the the weather like in Brussels?"
            command = Command.new(
                Bot.new("token", "bot mc-botface"),
                Slack::Api::PostMessageRequest.new(
                    "12345",
                    "ABC-123-DEF-456",
                    "tra la la la la"
                ),
                CommandType::HEAR,
                "what'*s the weather like in (\\w+)\\?*"
            )

            command.matches?(string_to_match).should be_false
        end

        it "doesn't match regex for DEMAND command type without bot name" do
            string_to_match = "whats the weather like in Brussels?"
            command = Command.new(
                Bot.new("token", "bot mc-botface"),
                Slack::Api::PostMessageRequest.new(
                    "12345",
                    "ABC-123-DEF-456",
                    "tra la la la la"
                ),
                CommandType::DEMAND,
                "what'*s the weather like in (\\w+)\\?*"
            )

            command.matches?(string_to_match).should be_false
        end

        it "matches regex for DEMAND command type with bot name" do
            string_to_match = "bot mc-botface whats the weather like in Brussels?"
            command = Command.new(
                Bot.new("token", "bot mc-botface"),
                Slack::Api::PostMessageRequest.new(
                    "12345",
                    "ABC-123-DEF-456",
                    "tra la la la la"
                ),
                CommandType::DEMAND,
                "what'*s the weather like in (\\w+)\\?*"
            )
            command.matches?(string_to_match).should be_true
        end

        it "matches regex for DEMAND command type with bot ID" do
            string_to_match = "<@0> whats the weather like in Brussels?"
            command = Command.new(
                Bot.new("token", "bot mc-botface"),
                Slack::Api::PostMessageRequest.new(
                    "12345",
                    "ABC-123-DEF-456",
                    "tra la la la la"
                ),
                CommandType::DEMAND,
                "what'*s the weather like in (\\w+)\\?*"
            )

            command.matches?(string_to_match).should be_true
        end
    end
end