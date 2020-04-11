pkill $(cat tmp/pids/server.pid)
rm -rf tmp/pids/server.pid
bundle install
rails db:migrate
annotate --models -i
annotate --routes
rails s