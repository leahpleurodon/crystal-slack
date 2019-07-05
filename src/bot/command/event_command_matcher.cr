require "../../slack/**"

class EventCommandMatcher
  def self.find_command_match(app : App, event : Slack::Api::Event) : Command | Nil
    App.singleton.logger.debug("finding matching command for event")
    matches = app.commands.select { |c| c.matches?(event.event_text) }
    if matches.size > 0 
      App.singleton.logger.info("matching command found")
      return matches.first 
    else 
      App.singleton.logger.debug("no matching command found for event: #{event.event_text}")
      return nil
    end
  end
end
