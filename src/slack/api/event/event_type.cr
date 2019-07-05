module Slack
  module Api
    enum EventType
      CHANNEL
      IM
      MPIM
      GROUP
      UNKNOWN
    end
  end
end
