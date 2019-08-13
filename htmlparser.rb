require 'yaml'
require 'open-uri'
require 'nokogiri'
require 'slack/incoming/webhooks'
require 'dotenv'

list = YAML.load_file("list.yaml")

list['siteurl'].each do | url |

  doc = Nokogiri::HTML(open(url).read)
  arr = Array.new
  doc.xpath('//nav//li//a').each do | node |
    arr << node
  end 

  str = arr[0].to_s
  str2 = str.gsub(/<a href="|">|<\/a>/,' ')

  Dotenv.load
  slack = Slack::Incoming::Webhooks.new ENV["APIKEY"]

  attachments = [{
    color: "#483D8B",
    fields: [
      {
      title: "妄想テレパシー最新話",
      value: "#{str2}",
      }
    ],
  }]

  slack.post "", attachments: attachments

end
