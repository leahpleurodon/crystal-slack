require "../../spec_helper"
require "../../../src/bot/command/**"
require "../../../src/slack/api/**"

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
      CommandType::HEAR,
      "what'*s the weather like in (\\w+)\\?*"
    )

    command.matches?(string_to_match).should be_true
  end

  it "doesn't match regex for HEAR command type without bot name" do
    string_to_match = "hows the the weather like in Brussels?"
    command = Command.new(
      Bot.new(ENV["SLACK_BOT_TOKEN"], "BOT"),
      CommandType::HEAR,
      "what'*s the weather like in (\\w+)\\?*"
    )

    command.matches?(string_to_match).should be_false
  end

  it "doesn't match regex for DEMAND command type without bot name" do
    string_to_match = "whats the weather like in Brussels?"
    command = Command.new(
      Bot.new(ENV["SLACK_BOT_TOKEN"], "BOT"),
      CommandType::DEMAND,
      "what'*s the weather like in (\\w+)\\?*"
    )

    command.matches?(string_to_match).should be_false
  end

  it "matches regex for DEMAND command type with bot name" do
    string_to_match = "BOT whats the weather like in Brussels?"
    command = Command.new(
      Bot.new(ENV["SLACK_BOT_TOKEN"], "BOT"),
      CommandType::DEMAND,
      "what'*s the weather like in (\\w+)\\?*"
    )
    command.matches?(string_to_match).should be_true
  end

  it "matches regex for DEMAND command type with bot ID" do
    string_to_match = "<@NOID> whats the weather like in Brussels?"
    command = Command.new(
      Bot.new(ENV["SLACK_BOT_TOKEN"], "BOT"),
      CommandType::DEMAND,
      "what'*s the weather like in (\\w+)\\?*"
    )

    command.matches?(string_to_match).should be_true
  end
  WebMock.reset
end

describe "GENERATE RESPONSES" do 
  WebMock.stub(:get, "https://slack.com/api/auth.test?token=#{ENV["SLACK_BOT_TOKEN"]}")
  .to_return(
    status: 200,
    body: "{
          \"ok\": true,
          \"url\": \"https:\/\/EXAMPLETEAM.slack.com\/\",
          \"team\": \"EXAMPLETEAM\",
          \"user\": \"PLEURODON\",
          \"team_id\": \"T36134603\",
          \"user_id\": \"U36P9P5FZ\"
      }",
    headers: {"mocked" => "true"}
  )
  event = Slack::Api::Event.new(
    event_type: Slack::Api::EventType::CHANNEL,
    event_channel: "12345",
    event_user: "54321",
    event_text: "1 + 1 =",
    event_t_stamp: "123123",
    event_time: "123123",
    event_channel_type: "CHANNEL"
  )
  bot = Bot.new(ENV["SLACK_BOT_TOKEN"], "BOT")
  command = Command.new(
    bot,
    CommandType::HEAR,
    "1 + 1 ="
  )

  it "auto generates a response that posts the correct details to slack API" do
    WebMock.stub(:post, "https://slack.com/api/chat.postMessage")
      .with(body: "channel=12345&thread_ts=0&text=window&as_user=true", headers: {"Content-Type" => "application/x-www-form-urlencoded", "Authorization" => "Bearer #{bot.token}"})
      .to_return(
        status: 200,
        body: "{\"ok\":true}",
        headers: {"mocked" => "true"}
      )
    
    auto_response = command.set_auto_response("window", event)
    posted_response = auto_response.post!

    json_body = JSON.parse(posted_response.body)
    posted_response.status_code.should eq(200)
    json_body["ok"].should be_true
  end
  WebMock.reset

  it "let you manually generate a response that posts the correct details to slack API" do
    WebMock.stub(:post, "https://slack.com/api/chat.postMessage")
      .with(body: "channel=DODOO&thread_ts=123123123&text=window&as_user=true", headers: {"Content-Type" => "application/x-www-form-urlencoded", "Authorization" => "Bearer #{bot.token}"})
      .to_return(
        status: 200,
        body: "{\"ok\":true}",
        headers: {"mocked" => "true"}
      )
    
    man_response = command.set_man_response(
                                            "window", 
                                            event, 
                                            "DODOO", 
                                            bot,
                                            "123123123"
    )
    posted_response = man_response.post!

    json_body = JSON.parse(posted_response.body)
    posted_response.status_code.should eq(200)
    json_body["ok"].should be_true
  end
  WebMock.reset
end