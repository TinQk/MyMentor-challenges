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
    2. Go to teachers management menu
    3. Go to requests management menu
    4. Exit application
    "

    case gets.chomp
    when '1' then p open_and_parse_data
    when '2' then return TeacherMenu.new(data_filename: @data_filename).call
    when '3' then return RequestMenu.new(data_filename: @data_filename).call
    when '4' then return
    else print 'Please enter a valid command.'
    end
    call
  end

  private

  def open_and_parse_data
    JSON.parse(File.read(@data_filename))
  end
end
