require 'json'

require_relative 'models/teacher'
require_relative 'models/field'
require_relative 'models/level'
require_relative 'lib/main_menu.rb'
require_relative 'lib/teacher_menu.rb'

MainMenu.new(data_filename: '../data.json').call
