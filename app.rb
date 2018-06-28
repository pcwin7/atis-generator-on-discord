require 'discordrb'
require 'nokogiri'
require 'open-uri'

bot = Discordrb::Commands::CommandBot.new token: ENV['ACCESS_TOKEN'], client_id: ENV['CLIENT_ID'], prefix: '!'

bot.command :atis do |event|
    icao = "RJTT"

    metarurl = "https://www.time-j.net/MetarApp/MetarTaf/#{icao}"

    charset = nil
    html = open(metarurl) do |f|
        charset = f.charset
        f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)
    metar = doc.xpath('/html/body/div/div/div/div/table/tr/td')[17].inner_text
    
    atisurl = "https://www.franomo.mlit.go.jp/Login.action"
    charset = nil
    html = open(atisurl) do |f|
        charset = f.charset
        f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)
    atis = doc.xpath('/html/body/div/table/tbody/tr/td/table/tbody/tr/td/table/tbody/tr/td/div/table/tbody/tr/td').inner_text


    event.send_message("#{metar}")
    event.send_message("#{atis}")
end

bot.run
