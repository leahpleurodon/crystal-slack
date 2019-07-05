require "./bot/**"
require "./slack/api/event/event_receiver"

class App
  getter bots : Array(Bot)
  getter commands : Array(Command)
  getter event : Slack::Api::Event
  getter logger : Logger

  def add_bot(bot : Bot)
    @bots.push(bot)
  end

  def run_app_server
    run_server
  end

  def set_event(event : Slack::Api::Event)
    @event = event
  end

  def add_command(command : Command)
    @commands.push(command)
  end

  def set_log_level(severity : Severity)
    @logger.level = severity
  end

  def self.singleton
    @@instance ||= new
  end

  private def initialize
    @bots = [] of Bot
    @commands = [] of Command
    @event = uninitialized Slack::Api::Event
    @logger = Logger.new(STDOUT, level: Logger::WARN)
  end
end
