require "octopus"
namespace :db do
  desc 'Build the databases for tests'
  task :build_databases do
    mysql_user = ENV['MYSQL_USER'] || "root"

    [:canada, :brazil, :mexico].each do |country|
      %x( echo "create DATABASE #{country}_shard DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci " | mysql --user=#{mysql_user})
    end
  end

  desc 'Drop the tests databases'
  task :drop_databases do
    mysql_user = ENV['MYSQL_USER'] || "root"

    [:canada, :brazil, :mexico].each do |country|
      %x( mysqladmin --user=#{mysql_user} -f drop #{country}_shard )
    end
  end

  desc 'Create tables on tests databases'
  task :create_tables do
    [:canada, :brazil, :mexico].each do |shard_symbol|
      ActiveRecord::Base.using(shard_symbol).connection.create_table(:schema_migrations) do |u|
        u.string :version, :unique => true, :null => false
      end
    end
  end
  
  desc 'Prepare the test databases'
  task :octopus => [:drop_databases, :build_databases, :create_tables]
end



