require 'yaml'
require 'open-uri'
require 'nokogiri'
require 'slack/incoming/webhooks'
require 'dotenv'

list = YAML.load_file("list.yaml")

list['siteurl'].each do | url |

    doc = Nokogiri::HTML(open(url).read)
    doc.xpath('//nav[@id="backnumbers"]').each do |href|
      puts href
    end
end
