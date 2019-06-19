require "../../spec_helper"
require "webmock"
require "json"

describe Slack::Api::AuthTestRequest do
  describe "#request_body" do
    it "gets an ok response" do
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
      response = Slack::Api::AuthTestRequest.new(ENV["SLACK_BOT_TOKEN"]).perform!

      json_body = JSON.parse(response.body)
      response.status_code.should eq(200)
      json_body["ok"].should be_true

      WebMock.reset
    end

    it "gets an error response" do
      WebMock.stub(:get, "https://slack.com/api/auth.test?token=#{ENV["SLACK_BOT_TOKEN"]}")
        .to_return(
        status: 200,
        body: "{
                \"ok\": false,
                \"error\": \"invalid_auth\"
            }",
        headers: {"mocked" => "true"}
      )

      response = Slack::Api::AuthTestRequest.new(ENV["SLACK_BOT_TOKEN"]).perform!

      json_body = JSON.parse(response.body)
      response.status_code.should eq(200)
      json_body["ok"].should be_false

      WebMock.reset
    end
  end
end
