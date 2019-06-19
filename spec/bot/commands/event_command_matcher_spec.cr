require "../../spec_helper"
require "../../../src/bot/command/**"
require "../../../src/slack/**"

module Bot
  describe "#find_command_match" do
    WebMock.stub(:get, "https://slack.com/api/auth.test?token=xoxb-108037142003-653114220229-lImeoxhWY7Kpt9SFtr5qClcY")
      .to_return(body: "{\"ok\":\"true\"}")
    bot1 = Bot.new(ENV["SLACK_BOT_TOKEN"], "BOT1")
    event1 = Slack::Api::Event.new(Slack::Api::EventType::CHANNEL,
      "CHANNEL111",
      "USER111",
      "what's the weather like in Brussels?",
      "0",
      "0",
      "channel"
    )
    event2 = Slack::Api::Event.new(Slack::Api::EventType::CHANNEL,
      "CHANNEL111",
      "USER111",
      "what's the forecast like in Brussels?",
      "0",
      "0",
      "channel"
    )
    command1 = Command.new(
      bot1,
      Slack::Api::PostMessageRequest.new(
        "CHANNEL111",
        "TEXT",
        bot1.token
      ),
      CommandType::HEAR,
      "what'*s the weather like in (\\w+)\\?*"
    )
    it "matches the command when 1 bot has 1 matching command" do
      app = App.singleton
      app.add_bot(bot1)
      app.add_command(command1)
      (EventCommandMatcher.find_command_match(app, event1)).should eq(command1)
    end
    it "finds no matches and returns nil when no commands" do
      app = App.singleton
      (EventCommandMatcher.find_command_match(app, event2)).should be_nil
    end
    WebMock.reset
  end
end
