namespace :git do
  desc "Push to github, pull on online server"
  task :push => :environment do
    puts 'Pushing...'
    `git push`
    puts 'Pulling on cgo.famboard.com and running migrations...'
    `ssh wtw2.familymembers.com 'cd /data/web/wtw && git pull && RAILS_ENV=production rake db:migrate && touch tmp/restart.txt'`
    puts 'Done.'  
  end
  desc "Push to github, pull on test server"
  task :test => :environment do
    puts 'Pushing...'
    `git push`
    puts 'Pulling on test server and running migrations...'
    `ssh wtw.web.ws.local 'cd /data/web/wtw && git pull && RAILS_ENV=production rake db:migrate && touch tmp/restart.txt'`
    puts 'Done.'  
  end
end
