require "../../slack/**"

module Bot
  class EventCommandMatcher
    def self.find_command_match(app : App, event : Slack::Api::Event) : Command | Nil
      matches = app.commands.select { |c| c.matches?(event.event_text) }
      matches.size > 0 ? matches.first : nil
    end
  end
end
