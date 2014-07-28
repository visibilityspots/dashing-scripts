require "net/https"
require "uri"

def fetch(uri_str, limit = 10)
  # You should choose a better exception.
  raise ArgumentError, 'too many HTTP redirects' if limit == 0

  response = Net::HTTP.get_response(URI(uri_str))

  case response
  when Net::HTTPSuccess then
    response
  when Net::HTTPRedirection then
    location = response['location']
    warn "redirected to #{location}"
    fetch(location, limit - 1)
  else
    response.value
  end
end

SCHEDULER.every '4s' do

  group_req = fetch('http://us.libraryh3lp.com/presence/jid/GROUP/chat.libraryh3lp.com/text')
  group = group_req.body

  user1_req = fetch('http://us.libraryh3lp.com/presence/jid/USER1/chat.libraryh3lp.com/text')
  user1 = user1_req.body

  user2_req = fetch('http://us.libraryh3lp.com/presence/jid/USER2/libraryh3lp.com/text')
  user2 = user2_req.body

  chat_status = []
  chat_status << {:label=>'Group', :value=>group}
  chat_status << {:label=>'User1', :value=>user1}
  chat_status << {:label=>'User2', :value=>user2}

  if group == 'away'
	color = 'orange'
  elsif group == 'unavailable'
	color = 'red'
  else
	color = 'green'
  end

  send_event('chat_stat', { items: chat_status, color: color})
end

