#!/usr/bin/env ruby
require 'foursquare2'

_api_client_id = ''
_api_client_secret = ''
_venue_id = ''

SCHEDULER.every '10m', :first_in => 0 do |job|
  venue = Foursquare2::Client.new(:client_id => _api_client_id, :client_secret => _api_client_secret)
  venue_checkins = venue.herenow(_venue_id)
  send_event('foursquare_checkins_people', current: venue_checkins['hereNow']['count'])
end

