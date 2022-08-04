# frozen_string_literal: true

require 'csv'

namespace :users do
  desc 'Create users from CSV file'

  task create_users: :environment do
    users = CSV.parse(File.read("#{Rails.root}/lib/tasks/users.csv"), headers: true)
    users.each do |user_params|
      user = User.new(user_params.to_h)
      puts '##################################'
      if user.save
        puts "# Succesfully created user: #{user.inspect}"
      else
        puts "# ERROR: Unable to create user: #{user.errors.inspect}"
      end
      puts '##################################'
    end
  end
end
