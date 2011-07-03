#require "octopus"
ActiveRecord::Base.logger = Octopus::Logger.new("#{Rails.root}/log/#{Rails.env}.log")
