require 'slack/incoming/webhooks'
require 'dotenv'

Dotenv.load
slack = Slack::Incoming::Webhooks.new ENV["APIKEY"]
slackvar = "test"

attachments = [{
  fields: [
    {
    title: "Project",
    value: "#{slackvar}",
    shor: true
  }
  ],
}]

slack.post "", attachments: attachments
