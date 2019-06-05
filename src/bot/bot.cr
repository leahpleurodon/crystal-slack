require "./command/command"

module Bot
    class Bot
        
        getter id : String
        getter name : String

        def initialize(
            token : String,
            name : String
        )
            @token = token
            @name = name
            @commands = [] of Command
            @id = "0" || slack_id
        end

        private def slack_id : String
            raise "NOT IMPLEMENTED"
        end
    end
end