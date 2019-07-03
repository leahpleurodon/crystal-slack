describe "#parsed_response" do
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
    WebMock.reset
end