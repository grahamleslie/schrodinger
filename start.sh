bundle install
rails db:migrate
annotate --models -i
annotate --routes
rails s