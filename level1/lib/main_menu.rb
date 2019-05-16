class MainMenu
  attr_accessor :data_filename

  def initialize(data_filename:)
    @data_filename = data_filename
    @data_parsed_content = open_and_parse_data
  end

  def call
    printf "
    - MAIN MENU -

    What do you want to do ?
    1. Show all data
    2. Go to teachers management
    3. Exit application
    "

    case answer = gets.chomp
      when "1" then p open_and_parse_data
      when "2" then return TeacherMenu.new(data_filename: @data_filename).call
      when "3" then return
      else print "Please enter a valid command."
    end
    return call
  end

  private

  def open_and_parse_data
    JSON.parse(File.read(@data_filename))
  end
end
