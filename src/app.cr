require "./bot/**"

class App
  getter bots : Array(Bot)
  getter commands : Array(Command)

  def add_bot(bot : Bot)
    @bots.push(bot)
  end

  def add_command(command : Command)
    @commands.push(command)
  end

  def self.singleton
    @@instance ||= new
  end

  private def initialize
    @bots = [] of Bot
    @commands = [] of Command
  end
end
