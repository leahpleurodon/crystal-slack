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

    it "sends the repsonse with the correct magic field calc for user" do
        WebMock.stub(:post, "https://slack.com/api/chat.postMessage").
            with(body: "channel=#{event.event_channel}&thread_ts=0&text=%3C%4054321%3E%2C+it+%3D+windows&as_user=true", headers: {"Content-Type" => "application/x-www-form-urlencoded", "Authorization" => "Bearer #{bot.token}"})
            .to_return(
                status: 200,
                body: "{\"ok\":true}",
                headers: {"mocked" => "true"}
              )
        response_posted = Response.new(
            event: event,
            text: "<!user!>, it = windows",
            channel: event.event_channel,
            bot: bot,
            timestamp: "0"
        ).post!

        json_body = JSON.parse(response_posted.body)
        response_posted.status_code.should eq(200)
        json_body["ok"].should be_true
    end
    WebMock.reset

    it "sends the repsonse with the correct magic field calc for channel" do
        WebMock.stub(:post, "https://slack.com/api/chat.postMessage").
            with(body: "channel=12345&thread_ts=0&text=12345%2C+it+%3D+windows&as_user=true", headers: {"Content-Type" => "application/x-www-form-urlencoded", "Authorization" => "Bearer #{bot.token}"})
            .to_return(
                status: 200,
                body: "{\"ok\":true}",
                headers: {"mocked" => "true"}
              )
        response_posted = Response.new(
            event: event,
            text: "<!channel!>, it = windows",
            channel: event.event_channel,
            bot: bot,
            timestamp: "0"
        ).post!

        json_body = JSON.parse(response_posted.body)
        response_posted.status_code.should eq(200)
        json_body["ok"].should be_true
    end
    WebMock.reset
end