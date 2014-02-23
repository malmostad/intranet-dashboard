require 'elasticsearch/rails/tasks/import'

namespace :elasticsearch do
  desc "Zero downtime reindexing
  $ rake environment elasticsearch:reindex CLASS='User' INDEX='employees_201402240920' ALIAS='employees FORCE=y'"
  task reindex: :environment do
    # TODO: check for arguments CLASS INDEX ALIAS FORCE
    aliaz = ENV["ALIAS"]
    index = ENV["INDEX"]

    client = Elasticsearch::Client.new
    has_alias = client.indices.exists_alias name: aliaz
    old_indices = has_alias ? client.indices.get_alias(name: aliaz).map {|k,v| k } : []

    # Creat new index
    Rake::Task["elasticsearch:import:model"].invoke

    client.indices.delete_alias(index: "*", name: aliaz) if has_alias
    client.indices.put_alias(index: index, name: aliaz)
    client.indices.delete(index: old_indices) if old_indices.present?
  end
end
