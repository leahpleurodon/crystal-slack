require "./bot/**"
class App
    getter bots : Array(Bot::Bot)
    getter commands : Array(Bot::Command)

    def initialize
        @bots = [] of Bot::Bot
        @commands = [] of Bot::Command
    end

    def add_bot(bot : Bot::Bot)
        @bots.push(bot)
    end

    def add_command(command : Bot::Command)
        @commands.push(command)
    end
end