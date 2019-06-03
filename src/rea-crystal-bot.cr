# TODO: Write documentation for `Rea::Crystal::Bot`
require "crest"
require "json"

module Rea::Crystal::Bot
  # VERSION = "0.1.0"

  # API_TOKEN = "xoxp-108037142003-108791787543-487620848434-8c45ae4d188bed8a4eedcfde1891c460"

  # request = Crest::Request.execute(:post,
  # "https://slack.com/api/chat.postMessage",
  # headers: {
  #   "Content-Type" => "application/json",
  #   "Authorization" => "Bearer #{API_TOKEN}"
  # },
  #   form: {"channel" => "C35CMH5K3", "text" => "testing", "as_user" => true}.to_json
  # )

  test = uninitialized JSON::Any

  puts test || true

end
