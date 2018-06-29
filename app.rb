require 'discordrb'
require 'nokogiri'
require 'open-uri'

bot = Discordrb::Commands::CommandBot.new token: ENV['ACCESS_TOKEN'], client_id: ENV['CLIENT_ID'], prefix: '!'

def scrape_metar(icao)
    metarurl = "https://www.time-j.net/MetarApp/MetarTaf/#{icao}"

    charset = nil
    html = open(metarurl) do |f|
        charset = f.charset
        f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)
    metar = doc.xpath('/html/body/div/div/div/div/table/tr/td')[17].inner_text
    
    return metar
end

def scrape_atis
    atisurl = "https://www.franomo.mlit.go.jp"
    charset = nil
    html = open(atisurl) do |f|
        charset = f.charset
        f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)
    atis = doc.xpath('//table[@class="atisinfo"]/tr/td').inner_text

    return atis
end

bot.command :atis do |event|
    icao = "RJTT"

    metar = scrape_metar(icao)
    atis = scrape_atis

    event.send_message("#{metar}")
    event.send_message("#{atis}")
end

bot.run
