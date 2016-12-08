require 'elasticsearch/rails/tasks/import'
Rake::TaskManager.record_task_metadata = true

namespace :elasticsearch do
  desc "Zero downtime re-indexing
  $ RAILS_ENV=development bundle exec rake environment elasticsearch:reindex CLASS='User' ALIAS='employees'"
  task reindex: :environment do |task|
    puts "\n[NOTICE] You will get a 404 error message below. That is expected.\n\n"

    if ENV['CLASS'].blank? || ENV['ALIAS'].blank?
      puts "USAGE:"
      puts task.full_comment
      exit(1)
    end

    ENV["FORCE"] = 'y' # must be set to force mapping
    aliaz = "#{ENV["ALIAS"]}_#{Rails.env}"
    ENV['INDEX'] = "#{aliaz}_#{Time.new.strftime('%Y%m%d%H%M%S')}"

    client = Elasticsearch::Client.new
    has_alias = client.indices.exists_alias name: aliaz
    old_indices = has_alias ? client.indices.get_alias(name: aliaz).map {|k,v| k } : []

    # Creat new index, command line arguments are used
    Rake::Task["elasticsearch:import:model"].invoke

    client.indices.delete_alias(index: "*", name: aliaz) if has_alias
    client.indices.put_alias(index: ENV['INDEX'], name: aliaz)
    client.indices.delete(index: old_indices) if old_indices.present?
  end
end
