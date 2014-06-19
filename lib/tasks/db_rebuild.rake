namespace :db do
  desc "Rebuild (drop, create, migrate) db. Then seed and clone."
  
  # rake db:rebuild 
  # OR 
  # rake db:rebuild[true,true]
  task :rebuild, [:skip_seeds, :skip_clean_gateway] => :environment do |t,args|
    raise "This task can not be run in this environment.  (Hint:  Use 'db:reload' for heroku.)" unless %w[development].include? Rails.env
    args.with_defaults(skip_seeds: "false",skip_clean_gateway:"false")
    
    # if something fails and you are unable to access the db, you can drop it with the following:
    # /usr/bin/dropdb 'store-dev'
    # /usr/bin/dropdb 'store-test'
    # modified from http://stackoverflow.com/a/5408501/444774

    puts "Forcibly disconnecting other processes from database...(You may need to restart them.)"

    require 'active_record/connection_adapters/postgresql_adapter'
    module ActiveRecord
      module ConnectionAdapters
        class PostgreSQLAdapter < AbstractAdapter
          def drop_database(name)
            begin
              psql_version_num = execute "select setting from pg_settings where name = 'server_version_num'"
              if psql_version_num.values.first.first.to_i < 90200
                #puts "version < 9.2"
                psql_version_pid_name = 'procpid'
              else
                #puts "version >= 9.2"
                psql_version_pid_name = 'pid'
              end

              execute <<-SQL
                UPDATE pg_catalog.pg_database
                SET datallowconn=false WHERE datname='#{name}'
              SQL

              execute <<-SQL
                SELECT pg_terminate_backend(pg_stat_activity.#{psql_version_pid_name})
                FROM pg_stat_activity
                WHERE pg_stat_activity.datname = '#{name}';
              SQL

              execute "DROP DATABASE IF EXISTS #{quote_table_name(name)}"
            ensure
              execute <<-SQL
                UPDATE pg_catalog.pg_database
                SET datallowconn=true WHERE datname='#{name}'
              SQL
            end
          end
        end
      end
    end            
    
    
    puts "Dropping the db..."
    Rake::Task['db:drop'].invoke
    puts "Creating the db..."
    Rake::Task['db:create'].invoke
    puts "Migrating the db..."
    Rake::Task['db:migrate'].invoke

    if args.skip_seeds == "false"
      puts "Seeding the db..."
      Rake::Task['db:seed'].invoke
    end

    puts "Cloning the test db..."
    Rake::Task['db:test:clone'].invoke
    puts "Done."
  end

  desc "Reload schema, then seed. (Does not try to drop and recreate db, which causes problems on heroku.)"
  task reload: :environment do
    puts "Dropping/loading the db..."
    Rake::Task['db:schema:load'].invoke
    puts "Seeding the db..."
    Rake::Task['db:seed'].invoke
    puts "Done."
  end
end