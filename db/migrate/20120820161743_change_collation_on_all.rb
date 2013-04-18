class ChangeCollationOnAll < ActiveRecord::Migration

  tables = %w(feed_entries feeds feeds_roles feeds_users roles roles_shortcuts roles_users schema_migrations sessions shortcuts shortcuts_users user_agents users)

  def up
    tables.each do |t|
      execute "ALTER TABLE #{t} CONVERT TO CHARACTER SET utf8 COLLATE utf8_swedish_ci;"
    end
  end

  def down
    tables.each do |t|
       execute "ALTER TABLE #{t} CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    end
  end
end
