require "../../spec_helper"
require "../../../src/bot/command/**"
require "../../../src/slack/api/*"

module Bot
  describe "#match?" do
    WebMock.stub(:get, "https://slack.com/api/auth.test?token=#{ENV["SLACK_BOT_TOKEN"]}")
      .to_return(
      status: 200,
      body: "{
                \"ok\": false,
                \"error\": \"invalid_auth\"
            }",
      headers: {"mocked" => "true"}
    )
    it "matches regex for HEAR command type without bot name" do
      string_to_match = "whats the weather like in Brussels?"
      command = Command.new(
        Bot.new(ENV["SLACK_BOT_TOKEN"], "BOT"),
        Slack::Api::PostMessageRequest.new(
          "CHANNEL111",
          "TEXT",
          ENV["SLACK_BOT_TOKEN"],
          "0"
        ),
        CommandType::HEAR,
        "what'*s the weather like in (\\w+)\\?*"
      )

      command.matches?(string_to_match).should be_true
    end

    it "doesn't match regex for HEAR command type without bot name" do
      string_to_match = "hows the the weather like in Brussels?"
      command = Command.new(
        Bot.new(ENV["SLACK_BOT_TOKEN"], "BOT"),
        Slack::Api::PostMessageRequest.new(
          "CHANNEL111",
          "TEXT",
          ENV["SLACK_BOT_TOKEN"],
          "0"
        ),
        CommandType::HEAR,
        "what'*s the weather like in (\\w+)\\?*"
      )

      command.matches?(string_to_match).should be_false
    end

    it "doesn't match regex for DEMAND command type without bot name" do
      string_to_match = "whats the weather like in Brussels?"
      command = Command.new(
        Bot.new(ENV["SLACK_BOT_TOKEN"], "BOT"),
        Slack::Api::PostMessageRequest.new(
          "CHANNEL111",
          "TEXT",
          ENV["SLACK_BOT_TOKEN"],
          "0"
        ),
        CommandType::DEMAND,
        "what'*s the weather like in (\\w+)\\?*"
      )

      command.matches?(string_to_match).should be_false
    end

    it "matches regex for DEMAND command type with bot name" do
      string_to_match = "BOT whats the weather like in Brussels?"
      command = Command.new(
        Bot.new(ENV["SLACK_BOT_TOKEN"], "BOT"),
        Slack::Api::PostMessageRequest.new(
          "CHANNEL111",
          "TEXT",
          ENV["SLACK_BOT_TOKEN"],
          "0"
        ),
        CommandType::DEMAND,
        "what'*s the weather like in (\\w+)\\?*"
      )
      command.matches?(string_to_match).should be_true
    end

    it "matches regex for DEMAND command type with bot ID" do
      string_to_match = "<@NOID> whats the weather like in Brussels?"
      command = Command.new(
        Bot.new(ENV["SLACK_BOT_TOKEN"], "BOT"),
        Slack::Api::PostMessageRequest.new(
          "CHANNEL111",
          "TEXT",
          ENV["SLACK_BOT_TOKEN"],
          "0"
        ),
        CommandType::DEMAND,
        "what'*s the weather like in (\\w+)\\?*"
      )

      command.matches?(string_to_match).should be_true
    end
    WebMock.reset
  end
end
