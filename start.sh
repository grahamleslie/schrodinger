bundle install
rake db:migrate
annotate --models -i
annotate --routes
rails s