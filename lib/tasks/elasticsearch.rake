require 'elasticsearch/rails/tasks/import'

namespace :elasticsearch do
  desc "Zero downtime reindexing
  $ rake environment elasticsearch:reindex CLASS='User' INDEX='employees_123' ALIAS='employees'
  "
  task reindex: :environment do
    # TODO: check for argument
    # TODO: catch not found index/alias errors

    alias_name = ENV["ALIAS"]
    index = ENV["INDEX"]
    klass = ENV["INDEX"]

    client = Elasticsearch::Client.new
    old_indices = client.indices.get_alias(name: alias_name).map {|k,v| k }

    # bundle exec rake environment elasticsearch:import:model CLASS='User' INDEX=index
    Rake::Task["elasticsearch:import:model"].invoke("CLASS=#{klass} INDEX=#{index}")

    client.indices.delete_alias index: "*", name: alias_name
    client.indices.put_alias index: index, name: alias_name
    client.indices.delete index: old_indices
  end
end
