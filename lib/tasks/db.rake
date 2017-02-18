namespace :db do
  desc "Optimize all database tables"
  task optimize_tables: :environment do
    t = Time.new.to_f
    tables = ActiveRecord::Base.connection.tables
    tables.each do |table|
      ActiveRecord::Base.connection.execute("OPTIMIZE TABLE #{table};")
    end
    puts "#{Time.now} Optimized #{tables.size} tables in #{(Time.new.to_f - t)} seconds"
  end
end
