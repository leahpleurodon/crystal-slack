require "../../spec_helper"
require "webmock"
require "json"


describe Bot::Bot do
  
  describe "#name" do
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
        bot = Bot::Bot.new
        bot.name.should eq("PLEURODON")

        WebMock.reset
    end
  end
    describe "#name" do
    it "gets a failed response from slack, default name" do
        
      WebMock.stub(:get, "https://slack.com/api/auth.test?token=#{ENV["SLACK_BOT_TOKEN"]}")
      .to_return(
          status: 200, 
          body: "{
              \"ok\": false,
              \"error\": \"invalid_auth\"
          }", 
          headers: {"mocked" => "true"}
      )
        bot = Bot::Bot.new
        bot.name.should eq("BOT")

        WebMock.reset
    end
  end

end