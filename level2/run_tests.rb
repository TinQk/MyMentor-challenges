require_relative 'models/teacher'
require_relative 'models/field'
require_relative 'models/level'
require_relative 'models/request'
require_relative 'lib/menu.rb'
require_relative 'lib/main_menu.rb'
require_relative 'lib/teacher_menu.rb'
require_relative 'lib/request_menu.rb'

require 'test/unit'

Test::Unit::AutoRunner.run(true, "tests/tc_teacher.rb")
Test::Unit::AutoRunner.run(true, "tests/tc_request.rb")
