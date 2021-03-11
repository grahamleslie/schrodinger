pkill $(cat tmp/pids/server.pid)
rm -rf tmp/pids/server.pid
bundle install
rails db:migrate
annotate --models -i
annotate --routes
CLEANUP_KEEP_LATEST_RUNS=3 rails s
