Dashing scripts
===============

This repository contains some scripts I wrote to use in my dashing setup to get a clear overview of stuff I need to now in one glimp.

http://shopify.github.io/dashing

Foursquare.rb
-------------

The sandwich bar I buy my lunch is in the center of Ghent. Where a lot of students 'study' and need some lunch too. Because I don't want to lose time waiting in a queue I had the wonderful idea of setting up a dashing widget which show me how many people checked in on foursquare in this popular venue.

I started writing a dashing job using the foursquare ruby wrapper of Matt Mueller (https://github.com/mattmueller/foursquare2). 

![alt text][foursquare]

In your dashing root directory you have to add this gem into the Gemfile.

	gem 'foursquare2'

And install this new gem using

	$ bundle install

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

Bacula-web.erb
--------------

We have a dashing dashboard to give an overview of our infrastructure. Icinga, jenkins, foreman, web-services, traffic times.. Almost everything is been captured.. Only for bacula I could not find an existing one.

So I decided to write one myself. The first idea was to scrape the bacula-web overview site and use that output in a dashing screen. Mainly because a missing API for bacula or bacula-web. Nevertheless scraping a website isn't the best idea if that layout changes your quite fucked up..

![alt text][bacula]

After googling around I came across an exampling of using mysql with ruby. So I decided to use this approach to have an overview of the bacula status.

In you dashing root directory you have to add this gem into the Gemfile.

	gem 'dbi'

And install this new gem using
	
	$ bundle install

Now copy the bacula-web.rb into the jobs directory and fill in your mysql details of your bacula director machine. I created a special mysql user which only can execute the select command from the dashing server to the mysql database.

Next step is to insert the html code in your dashing file dashingRootDir/dashboards/####.erb

    <li data-row="1" data-col="2" data-sizex="1" data-sizey="1">
          <div data-id="bacula-web" data-view="List" data-unordered="true" data-title="Backup state" onclick="window.open('http://your.bacula-web.instance/','Bacula-web');";></div>
    </li>

So now you have an overview of the backup jobs of the last 24hrs in your dashing setup.

Be aware I'm not a database admin nor a ruby developer so I pretty sure the queries or the ruby code could be rewritten in a more better way. If you have time I gladly accept pull requests for them :)

[foursquare]: https://github.com/visibilityspots/images/foursquare.png "Foursquare dashboard"
[bacula]: https://github.com/visibilityspots/images/bacula.png "Bacula dashboard"

