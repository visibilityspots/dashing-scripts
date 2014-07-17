require 'rubygems'
require 'pg'
require 'dbi'

db_driver = 'postgres'
db_name = 'bacula'
db_user = ''
db_password = ''
db_host = ''
db_port = '5432'

SCHEDULER.every '4s' do

  if db_driver == 'postgres'
    # Gathering Data from Postgres database
    conn=PGconn.connect( :hostaddr=>db_host, :port=>db_port, :dbname=>db_name, :user=>db_user, :password=>db_password)

    completed = conn.exec("select count(*) as Completed from Job WHERE RealEndTime >= NOW() - INTERVAL '24' HOUR AND JobStatus = 'T';")
    failing = conn.exec("select count(*) as Failed from Job WHERE RealEndTime >= NOW() - INTERVAL '24' HOUR AND JobStatus IN ('f', 'E');")
    cancelled = conn.exec("select count(*) as Cancelled from Job WHERE RealEndTime >= NOW() - INTERVAL '24' HOUR AND JobStatus = 'A';")
    running = conn.exec("select count(*) as Running from Job WHERE JobStatus = 'R';")
    waiting = conn.exec("select count(*) as Waiting from Job WHERE JobStatus IN ('F','S','M','m','s','j','c','d','t','p','C');")

    completedJobs = Integer(completed.getvalue(0,0))
    failingJobs = Integer(failing.getvalue(0,0))
    cancelledJobs = Integer(cancelled.getvalue(0,0))
    waitingJobs = Integer(waiting.getvalue(0,0))
    runningJobs = Integer(running.getvalue(0,0))

    completed.clear
    failing.clear
    cancelled.clear
    running.clear
    waiting.clear

    conn.close

  elsif db_driver == 'mysql'

    # Gathering Data from MySQL database
    dbh=DBI.connect('DBI:Mysql:db_name:db_host',db_user,db_password)

    completed = "select count(*) as Completed from Job WHERE `RealEndTime` >= DATE_SUB(NOW(),INTERVAL 24 HOUR) AND JobStatus = 'T';"
    failing = "select count(*) as Failed from Job WHERE `RealEndTime` >= DATE_SUB(NOW(),INTERVAL 24 HOUR) AND DATE(NOW()) AND JobStatus IN ('f', 'E');"
    cancelled = "select count(*) as Cancelled from Job WHERE `RealEndTime` >= DATE_SUB(NOW(),INTERVAL 24 HOUR) AND JobStatus = 'A';"
    running = "select count(*) as Running from Job WHERE JobStatus = 'R';"
    waiting = "select count(*) as Waiting from Job WHERE JobStatus IN ('F','S','M','m','s','j','c','d','t','p','C');"

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

  end

  # If statement to declare color according to state
  if failingJobs > 0
    value = failingJobs
    color = 'red' + "-blink"
  elsif waitingJobs > 0
    value = waitingJobs
    color = 'yellow'
  else
    value = completedJobs
    color = 'green'
  end

  # Update the simplemon widget
  send_event('bacula', {
   value: value,
   color: color
  })

end
