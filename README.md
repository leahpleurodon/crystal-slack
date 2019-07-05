# rea-crystal-bot

This gem is designed to make creating apps for slack in crystal easy... version 0 currently only supports sending/receiving messages via the slack Events API.
Keep an eye on the repo to see when new features are coming.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
    dependencies:
      crystal-slack:
        github: leahpleurodon/crystal-slack
   ```

2. Run `shards install`

## Usage

Crystal-slack shard is aimed to be as unopinionated as possible while still being user friendly... 

Your bot can just listen for events and it can respond to them. 

## Bots
You can create several bots in your app if you so choose.

To create a bot, your bot requires a slack bot token, to acquire one, follow [these instructions](https://api.slack.com/bot-users#), (the creating a bot section and installing to workspace section, sections 1 and 3).

```crystal
  bot = Bot.new(BOTSLACKTOKEN, optional-name)
```

## Commands
Commands are actions that the bot performs when it picks up specified events...

Creating commands is super easy, create a class that inherits from the command class... the call method must be over-ridden becausen it is the method the server will run when the command is called.
```crystal
  require "crystal-slack"
  class CustomCommand < Command
      def call(event : Slack::Api::Event)
          #do some really cool stuff
          #pretty much anything goes
      end
  end
```
To create the command object from our custom command that the bot will interact with create the following
```crystal
  CustomCommand.new(
    Bot.new(TOKEN, NAME), 
    CommandType::HEAR, 
    "hello..." 
  )
```
The above command will listen for any messages that equal exactly "hello..." you may put regex in this field to match dynamically... the action that will occur as a result of the command being matched is specified in the CustomCommand class as shown above.

## Command Types

The CommandTypes are especially fun, they save a little bit of string interpolation/regex by allowing you to specify whether or not you want the bots name/id to be called before the command.

The two command types are `CommandType::DEMAND` and `CommandType::HEAR`

Using `CommandType::HEAR` means that the bot does not need to be called in the message, think of it as an "as is" matcher.

Using `CommandType::DEMAND`  allows you to specify that the bot needs to be called specifically using it's `@handle` or it's display name before the pattern/ string to match. e.g. for the command below, the message `"hello..."` will not match... in order to invoke this command the message would have to read `"@botname hello..."` or `bot-display-name hello...`

```crystal
  CustomCommand.new(
    bot: Bot.new(TOKEN, NAME), 
    command_type: CommandType::DEMAND, 
    matcher: "hello..." 
  )
```

## Response

Now the real stuff begins... so you want your bot to say stuff...who doesn't? This is where the Response class comes in...

You can create a response and make it post at any time using the `post!` command on the Response

e.g the following repsonse sends "is it me you're looking for" to the specified channel... 
```crystal
  Response.new(
              text: "is it me you're looking for",
              channel: CHANNELID,
              bot: BOT,
              timestamp: "0"
          ).post!
```

The timestamp is the only real gotcha here, in order to post in the channel and not in a thread the time stamp must be "0" otherwise the timestamp of the thread as a string is required.

## Logging 
Crystal slack comes with a logger in built into the App singleton class... 
the default log level is warning...

to change the log level use following method:

```crystal
  App.singleton.set_log_level(severity: Severity::INFO)
```
Severity levels are defined by crystal [see here for more info.](https://crystal-lang.org/api/0.24.2/Logger.html)

## Putting it all together...
Here I have a simple app with a bot that response to any messages that equal `"hello..."` with `"is it me you're looking for"`

```crystal
#richie_bot.cr
require "crystal-slack"
require "./richie_command"

module RichieBot
  app = App.singleton
  app.set_log_level(Severity::DEBUG)
  bot = Bot.new("xoxb-XXXXXXXXXXX-XXXXXXXXXX-XXXXXXXXXXXXX")
  command = RichieCommand.new(
    bot,
    CommandType::HEAR,
    "hello..."
  )
  app.add_bot(bot)
  app.add_command(command)
  app.run_app_server
end
```
```crystal
# richie_command.cr
require "crystal-slack"
class RichieCommand < Command
    def call(event : Slack::Api::Event)
        Response.new(
            text: "is it me you're looking for",
            channel: event.event_channel,
            bot: @bot,
            timestamp: "0"
        ).post!
        App.singleton.logger.info("posted the response 'is it me you\'re looking for' in the channel: #{event.event_channel}")
    end
end
```

# Slack set up.

You need to [create a slack app](https://api.slack.com/apps) and add a bot user.
Following that you need to enable the events api see [this slack article](https://api.slack.com/bot-users#setup-events-api) on how to do so.

The following events are currently supported by the shard:
- message.channels

  A message was posted to a channel

- message.groups
  
  A message was posted to a private channel

- message.im
  
  A message was posted in a direct message channel

message.mpim
  
  A message was posted in a multiparty direct message channel

## Testing your app
What you will notice is that the events API  the events api requires an endpoint to send the events to... if you wish to test locally rather than in the cloud, [this article](https://api.slack.com/tutorials/tunneling-with-ngrok) is a useful article written by slack on how to do so.

## Contributing

1. Fork it (<https://github.com/leahpleurodon/crystal-slack/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Leah](https://github.com/leahpleurodon) - creator and maintainer
