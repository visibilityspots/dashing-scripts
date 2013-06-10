Dashing scripts
===============

This repository contains some scripts I wrote to use in my dashing setup to get a clear overview of stuff I need to now in one glimp.

http://shopify.github.io/dashing

Foursquare.rb
-------------

The sandwich bar I buy my lunch is in the center of Ghent. Where a lot of students 'study' and need some lunch too. Because I don't want to lose time waiting in a queue I had the wonderful idea of setting up a dashing widget which show me how many people checked in on foursquare in this popular venue.

I started writing a dashing job using the foursquare ruby wrapper of Matt Mueller (https://github.com/mattmueller/foursquare2). In you dashing root directory you have to add this gem into the Gemfile.

	gem 'foursquare2'

And install this new gem using

	$ bundle

Once that's done you copy the foursquare.rb file into the dashingRootDir/jobs/ directory and complete the script using those parameters.

	_api_client_id = ''
	_api_client_secret = ''
	_venue_id = '4c73902d57b6a1435a69c8cc'

The api credentials you can get from https://foursquare.com/developers/apps where you have to register a new app. The venue id on the other hand you can strip off from the url of the venue. 

example: https://foursquare.com/v/97/4c73902d57b6a1435a69c8cc the venue_id would be '4c73902d57b6a1435a69c8cc'

In your dashboard file dashingRootDir/dashboards/####.erb you can use this code to show the total of checked in people at your venue on your dashing dashboard:

    <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="foursquare_checkins_people" data-view="Number" data-title="People checked in @YOURVENUENAME" style="background-color: #80c02d"></div>
    </li>

No more waiting queues for you ;)



