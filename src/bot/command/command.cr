require "../**"
require "../exception/invalid_command_type"
require "../../slack/api/*"

class Command

  def initialize(
    bot : Bot,
    command_type : CommandType,
    matcher : String
  )
    @bot = bot
    @command_type = command_type
    @matcher = matcher
  end

  def matches?(string : String) : Bool
    case @command_type
    when CommandType::HEAR
      return matches_hear?(string)
    when CommandType::DEMAND
      return matches_demand?(string)
    else
      raise InvalidCommandType.new("invalid command type provided to bot")
    end
  end

  def call(event : Slack::Api::Event)
    # This method should get over-ridden
    puts "method not implemented."
  end

  private def matches_demand?(string : String) : Bool
    match = /\A(?:#{@bot.name}\s|<@#{@bot.id}>\s)+#{@matcher}\z/i =~ string
    !!match
  end

  private def matches_hear?(string : String) : Bool
    match = /\A#{@matcher}\z/i =~ string
    !!match
  end
end
