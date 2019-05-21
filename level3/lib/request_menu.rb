class RequestMenu < Menu
  # MAIN MENU

  def call
    printf "
    - REQUESTS MANAGEMENT -

    What do you want to do ?
    1. Display all requests
    2. Make a new request (search for a teacher)
    3. Plan courses for a specific request
    4. Delete a request
    5. Save modifications
    6. Go back to main menu
    "

    case gets.chomp
    when '1'
      display_requests
    when '2'
      new_request
    when '3'
      add_courses(select_request)
    when '4'
      delete_request(select_request)
    when '5'
      rewrite_requests
    when '6'
      return MainMenu.new(data_filename: @data_filename).call
    else
      print 'Please enter a valid command.'
    end

    call
  end

  # FUNCTIONS

  def new_request
    # Auto choose id
    id = @requests.empty? ? 1 : @requests.last.id + 1

    # Ask for new client's name
    print "Client's firstname ?"; fn = gets.chomp
    print "Client's lastname ?"; ln = gets.chomp

    # Ask for the skill's field
    display_fields
    print 'what field does (s)he wants to learn ? Enter a number'
    answer = gets.chomp
    field = @fields.select { |f| f.id == answer.to_i }.first

    # Ask for the skill's level
    display_levels
    print "At which level does (s)he wants to learn #{field.name} ? Enter a number"
    answer = gets.chomp
    level = @levels.select { |l| l.id == answer.to_i }.first

    print 'Searching ...'

    # Assemble skill and search for teachers
    skill = { field: field, level: level }
    potent_teachers = @teachers.select { |t| t.skills.include?(skill) }

    # Cancel request if no teacher matches
    if potent_teachers.empty?
      print 'Sorry but no teachers with this skill is available at the moment'
      return
    end

    # Add a random price_per_hour
    price_per_hour = rand(10..30)

    # If at least one teacher matches, create request
    teacher = potent_teachers.sample
    @requests << r = Request.new(id, fn, ln, level, field, teacher, price_per_hour)

    # Display summary
    printf "
  request created !
  id: #{r.id}
  client: #{r.client_firstname} #{r.client_lastname}
  level: #{r.level.grade}, #{r.level.cycle}
  field: #{r.field.name}
  teacher selected: #{r.selected_teacher.firstname} #{r.selected_teacher.lastname}
  price_per_hour: #{r.price_per_hour}
    "
  end

  def delete_request(request)
    @requests -= [request]
    print "Request deleted, don't forget to save your changes"
  end

  def select_request
    display_requests
    print "Enter the id of the request"
    answer = gets.chomp
    @requests.select { |t| t.id == answer.to_i }.first
  end

  def add_courses(request)
    print "Enter a date for the course to plan (yyyy-mm-dd)"
    date = gets.chomp.to_s
    print "How long will last the course in hours ?"
    length = gets.chomp.to_i

    course = { date: date, length: length }
    request.courses << course

    print "Course created, don't forget to save your modifications."
  end

  # SAVE IN JSON

  def rewrite_requests
    output = open_and_parse_data
    output['requests'] = @requests.map(&:to_json)

    File.open(@data_filename, 'w') do |f|
      f.write(JSON.pretty_generate(output))
    end

    p 'Saved in JSON'
  end
end
