ENV['TZ'] = 'Asia/Tokyo'
require_relative 'config/init'
require_relative 'database_management'
require_relative 'show_helper'

load App.root.join 'main.rb'
