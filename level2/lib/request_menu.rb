class RequestMenu
  attr_accessor :data_filename

  def initialize(data_filename:)
    @data_filename = data_filename
    # build records from json
    @fields = build_fields_from_data
    @levels = build_levels_from_data
    @teachers = build_teachers_from_data
    @requests = build_requests_from_data
  end

  # MAIN MENU

  def call
    printf "
    - REQUESTS MANAGEMENT -

    What do you want to do ?
    1. Display all requests
    2. Make a new request (search for a teacher)
    3. Delete a request
    4. Save modifications
    5. Go back to main menu
    "

    case gets.chomp
    when '1'
      display_requests
    when '2'
      new_request
    when '3'
      display_requests
      return delete_request(select_request)
    when '4'
      rewrite_requests
    when '5'
      return MainMenu.new(data_filename: @data_filename).call
    else
      print 'Please enter a valid command.'
    end

    call
  end

  # FUNCTIONS RELATED TO TEACHERS

  def display_requests
    format = '%-5s %-15s %s'
    print "\n    " + format(format, 'Id', 'Firstname', 'Lastname')
    @teachers.each do |teacher|
      print "\n    " + format(format, teacher.id, teacher.firstname, teacher.lastname)
    end
    print "\n\n"
  end

  def new_request
    # Auto choose id
    id = @teachers.empty? ? 1 : @teachers.last.id + 1

    # Ask for new teacher's name
    print "Teacher's firstname ?"; fn = gets.chomp
    print "Teacher's lastname ?"; ln = gets.chomp

    # Create teacher
    @teachers << t = Teacher.new(id, fn, ln)
    p 'Do you want to add skills to the teacher ? y/n '
    add_skills_to_teacher(t) if gets.chomp == 'y'

    # Display summary
    printf "
  teacher created !
  id: #{t.id}
  firstname: #{t.firstname}
  lastname: #{t.lastname}
  skill:
  #{display_skills(t)}
    "
  end

  def delete_request(request)
    @requests -= [request]
    print "Request deleted, don't forget to save your changes"
  end

  def select_request
    print "Enter the id of the request (enter 's' to show requests)"
    case answer = gets.chomp.to_i
    when 's' then display_requests; return select_request
    else return @requests.select { |t| t.id == answer.to_i }.first
    end
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

  private

  def open_and_parse_data
    JSON.parse(File.read(@data_filename))
  end

  def build_teachers_from_data
    teachers_json = open_and_parse_data.fetch('teachers')
    teachers = teachers_json.map do |h1|
      Teacher.new(
        h1['id'], h1['firstname'], h1['lastname'],
        h1['skills'].map { |h2| { field: @fields.select { |f| f.id == h2['field'] }.first, level: @levels.select { |l| l.id == h2['level'] }.first } }
      )
    end
    teachers.sort_by!(&:id)
  end

  def build_fields_from_data
    fields = open_and_parse_data.fetch('fields')
    fields.map! { |h| Field.new(h['id'], h['name']) }
    fields.sort_by!(&:id)
  end

  def build_levels_from_data
    levels = open_and_parse_data.fetch('levels')
    levels.map! { |h| Level.new(h['id'], h['grade'], h['cycle']) }
    levels.sort_by!(&:id)
  end

  def build_requests_from_data
    requests_json = open_and_parse_data.fetch('requests')
    requests = requests_json.map do |h1|
      Request.new(
        h1['id'],
        h1['client_full_name'],
        @levels.select { |l| l.id == h2['level'] }.first,
        @fields.select { |f| f.id == h2['field'] }.first
      )
    end
    requests.sort_by!(&:id)
  end
end
