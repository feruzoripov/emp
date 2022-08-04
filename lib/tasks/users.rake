require 'csv'

namespace :users do
  desc 'Create users from CSV file'

  task :create_users => :environment do
    users = CSV.parse(File.read("#{Rails.root}/lib/tasks/users.csv"), headers: true)
    users.each do |user_params|
      user = User.new(user_params.to_h)
      if user.save
        puts '##################################'
        puts "# Succesfully created user: #{user.inspect}"
        puts '##################################'
      else
        puts '##################################'
        puts "# ERROR: Unable to create user: #{user.errors.inspect}"
        puts '##################################'
      end
    end
  end
end
