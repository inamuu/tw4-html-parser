require 'yaml'
require 'open-uri'
require 'nokogiri'
require 'slack/incoming/webhooks'
require 'dotenv'

class Tw4HtmlParser
  def initialize(site_url)
    @list = site_url
  end

  def site_parser
    @list['siteurl'].each do | url |
      doc = Nokogiri::HTML(open(url).read)
      arr = Array.new
      doc.xpath('//nav//li//a').each do | node |
        arr << node
      end

      str = arr[0].to_s
      @@notify_url = str.gsub(/<a href="|">|<\/a>/,' ')
    end
  end

  def notify_slack
    Dotenv.load
    slack = Slack::Incoming::Webhooks.new ENV["APIKEY"]
    notify_url = @@notify_url
    attachments = [{
      color: "#483D8B",
      fields: [
        {
        title: "妄想テレパシー最新話",
        value: notify_url,
        }
      ],
    }]
    slack.post "", attachments: attachments
  end
end

list = YAML.load_file("list.yaml")
res = Tw4HtmlParser.new(list)
res.site_parser
res.notify_slack
