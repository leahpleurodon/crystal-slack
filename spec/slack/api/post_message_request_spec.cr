require "../../spec_helper"
require "webmock"
require "json"


describe Slack::Api::PostMessageRequest do
  channel = "12345"
  text = "tra la la la la"

  describe "#request_body" do
    it "gets an ok response" do

      WebMock.stub(:post, "https://slack.com/api/chat.postMessage").
        with(body: "channel=12345&thread_ts=0&text=tra+la+la+la+la&as_user=true", headers: {"Content-Type" => "application/x-www-form-urlencoded", "Authorization" => "Bearer #{ENV["SLACK_BOT_TOKEN"]}"})
        .to_return(
          status: 200, 
          body: "{\"ok\":true,\"channel\":\"12345\",\"ts\":\"1558761038.005300\",\"message\":{\"bot_id\":\"BEARYJH3J\",\"type\":\"message\",\"text\":\"tra la la la la\",\"user\":\"U36P9P5FZ\",\"ts\":\"1558761038.005300\"}}", 
          headers: {"mocked" => "true"}
        )

      response = Slack::Api::PostMessageRequest.new(
        channel,
        text
      ).perform!

      json_body = JSON.parse(response.body)
      response.status_code.should eq(200)
      json_body["ok"].should be_true

      WebMock.reset
    end

    it "gets an error response" do

      WebMock.stub(:post, "https://slack.com/api/chat.postMessage").
        with(body: "channel=12345&thread_ts=0&text=tra+la+la+la+la&as_user=true", headers: {"Content-Type" => "application/x-www-form-urlencoded", "Authorization" => "Bearer #{ENV["SLACK_BOT_TOKEN"]}"})
        .to_return(
          status: 200, 
          body: "{
            \"ok\": false,
            \"error\": \"channel_not_found\"
          }", 
          headers: {"mocked" => "true"}
        )

      response = Slack::Api::PostMessageRequest.new(
        channel,
        text
      ).perform!

      json_body = JSON.parse(response.body)
      response.status_code.should eq(200)
      json_body["ok"].should be_false

      WebMock.reset
    end

  end

end