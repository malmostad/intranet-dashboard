# -*- coding: utf-8 -*-
class SetDefaultValuesOnUser < ActiveRecord::Migration

  def up
    change_column_default(:users, :first_name, 'Förnamn saknas')
    change_column_default(:users, :last_name, 'Efternamn saknas')
    change_column_default(:users, :email, 'E-post saknas')

    User.all.each do |u|
      if u.first_name == nil
        u.first_name = 'Förnamn saknas'
      end

      if u.last_name == nil
        u.last_name = 'Efternamn saknas'
      end

      if u.email == nil
        u.email = 'E-post saknas'
      end
      u.save(validate: false)
    end
  end
end
