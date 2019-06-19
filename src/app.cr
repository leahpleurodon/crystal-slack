require "./bot/**"

class App
  getter bots : Array(Bot::Bot)
  getter commands : Array(Bot::Command)

  def add_bot(bot : Bot::Bot)
    @bots.push(bot)
  end

  def add_command(command : Bot::Command)
    @commands.push(command)
  end

  def self.singleton
    @@instance ||= new
  end

  private def initialize
    @bots = [] of Bot::Bot
    @commands = [] of Bot::Command
  end
end
