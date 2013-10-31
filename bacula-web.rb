require 'rubygems'
require 'dbi'

SCHEDULER.every '4s' do
  
  # Gathering Data from MySQL database
  dbh=DBI.connect('DBI:Mysql:DBNAME:HOST','USERNAME','PASSWORD')

  completed = "select count(*) as Completed from Job WHERE `EndTime` BETWEEN DATE(NOW() - INTERVAL 1 DAY) AND DATE(NOW()) AND JobStatus = 'T';"
  failing = "select count(*) as Failed from Job WHERE `EndTime` BETWEEN DATE(NOW() - INTERVAL 1 DAY) AND DATE(NOW()) AND JobStatus IN ('f', 'E');"
  cancelled = "select count(*) as Cancelled from Job WHERE `EndTime` BETWEEN DATE(NOW() - INTERVAL 1 DAY) AND DATE(NOW()) AND JobStatus = 'A';"
  running = "select count(*) as Running from Job WHERE `EndTime` BETWEEN DATE(NOW() - INTERVAL 1 DAY) AND DATE(NOW()) AND JobStatus = 'R';"
  waiting = "select count(*) as Waiting from Job WHERE `EndTime` BETWEEN DATE(NOW() - INTERVAL 1 DAY) AND DATE(NOW()) AND JobStatus IN ('F','S','M','m','s','j','c','d','t','p','C');"
 
   
  completedJobs = dbh.select_one(completed)
  completedJobs = Integer(completedJobs[0])

  failingJobs = dbh.select_one(failing)
  failingJobs = Integer(failingJobs[0])

  cancelledJobs = dbh.select_one(cancelled)
  cancelledJobs = Integer(cancelledJobs[0])

  runningJobs = dbh.select_one(running)
  runningJobs = Integer(runningJobs[0])

  waitingJobs = dbh.select_one(waiting)
  waitingJobs = Integer(waitingJobs[0])
  
  dbh.disconnect if dbh

  # Pushing gathered data into array
  bacula_states = Array.new

  bacula_states.push({
        label: "Completed",
        value: completedJobs 
  })

  bacula_states.push({
        label: "Failed",
        value: failingJobs
  })

  bacula_states.push({
        label: "Running",
        value: runningJobs
  })
  bacula_states.push({
        label: "Waiting",
        value: waitingJobs
  })

  bacula_states.push({
        label: "Cancelled",
        value: cancelledJobs
  })

  # Update the List widget
  send_event('bacula-web', { 
   items: bacula_states,
  })
end
