# -*- coding: utf-8 -*-
namespace :stats do
  task roles: :environment do
    roles = {}
    [:total, :department, :working_field].each { |category| roles[category] = {} }

    User.all.each do |user|
      [:total, :department, :working_field].each do |category|
        if category == :total
          n = user.roles.count
        else
          n = user.roles.where(category: category).count
        end
        if roles[category][n].nil?
          roles[category][n] = 0
        end
        roles[category][n] += 1
      end
    end
    [:total, :department, :working_field].each do |category|
      puts category.to_s.titlecase
      roles[category].sort.each do |key, val|
        puts "  #{key}: #{val}"
        # puts "  #{Hash[roles[category].sort]}"
      end
    end
  end
end
