task 'ridgepole:apply' => :environment do
  ENV['RAILS_ENV'] ||= "development"
  sh "bundle exec ridgepole -E#{ENV['RAILS_ENV']} -c config/database.yml --apply"
end

task 'ridgepole:export' => :environment do
  ENV['RAILS_ENV'] ||= "development"
  sh "bundle exec ridgepole -E#{ENV['RAILS_ENV']} -c config/database.yml --export -o Schemafile"
end
