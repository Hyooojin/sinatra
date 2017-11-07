require 'sinatra'
# http://www.sinatrarb.com/intro-ko.html
require 'nokogiri'
require 'httparty'
require 'uri'

get '/' do
    send_file 'index.html'
end

# get '/welcome' do
#     "welcome!"
# end



get '/lunch' do
    lunch = ["20층", "김밥카페", "순남시래기", "시골집"]
    @photos = {
            "20층" => "https://scontent-sea1-1.cdninstagram.com/t51.2885-15/s480x480/e35/20987024_1431422050287339_2004189507347283968_n.jpg?ig_cache_key=MTU4NzUwMTg2NjEwNzc3MTI0Nw%3D%3D.2",
            "김밥카페"=>"data:image/jpeg;base64,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", 
            "순남시래기"=>"http://scontent.cdninstagram.com/t51.2885-15/s480x480/e35/15048244_1813930468881270_5832233801744384000_n.jpg?ig_cache_key=MTM4ODIyNzU5Njg5ODExNDMzOQ%3D%3D.2",
            "시골집"=>"https://scontent-frt3-2.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/20589401_1470330933013006_752341887867682816_n.jpg"
    }
    @menu = lunch.sample
    # @photo = photos[@menu]
    erb :lunch
end
# 1.lunch menu를 추천해주도록 한다.
#     send_file 'lunch.html'
# 2.해당하는 점심메뉴의 이미지도 뿌려주도록 한다. 
    # file하나를 새로 만든다. lunch.html




get '/lotto' do
    @lotto = (1..45).to_a.sample(6)
    erb :lotto
end
# reload할 때 마다 새로운 lunch 메뉴가 나온다.

# 사용자에게 이름을 출력해주는 
get '/welcome/:name' do
    "Welcome! #{params[:name]}"
end
# "welcome! " + :name

# 사용자에게 3제곱을 출력해준다.

get '/cube/:num' do
    input = params[:num].to_i
    result = input ** 3
    "The result is #{result}"
end

 # "#{params[:num]}의 세제곱= " + params[:num].to_i ** 3

get '/lol' do
    erb :lol
end

get '/search' do
   url = "http://www.op.gg/summoner/userName="
   @id = params[:userName]
   @keyword = URI.encode(@id)
   res = HTTParty.get(url + @keyword)
   text = Nokogiri::HTML(res.body)
   @win = text.css('#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.wins')
   @lose = text.css('#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.losses')
   
   
   
   
   
    # 받을 때는 params를 사용 sinatra가 제공하는 hash이다.
    @keyword = params[:userName]
    "#{@keyword}"
    # params = {:userName => "멜팅탁"} #이런식으로 저장 될 것
    # params[:userName]
    
   
   
   
   
   
   
   
   
    # url = "http://www.op.gg/summoner/userName="
    # response = HTTParty.get(url)
    # text = Nokogiri::HTML(response.body)
    # fighting = text.css('#highcharts-2 > svg > g.highcharts-series-group > g.highcharts-series.highcharts-series-0 > path:nth-child(1)')
    
    # @url = params[:url] 
    
    erb :search
end