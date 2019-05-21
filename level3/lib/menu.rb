class Menu
  attr_accessor :data_filename

  def initialize(data_filename:)
    @data_filename = data_filename
    build_records
  end

  # Display methods

  def display_fields
    format = '%-5s %s'
    print "\n    " + format(format, 'Id', 'Name')
    @fields.each do |field|
      print "\n    " + format(format, field.id, field.name)
    end
    print "\n\n"
  end

  def display_levels
    format = '%-5s %-15s %s'
    print "\n    " + format(format, 'Id', 'Grade', 'Cycle')
    @levels.each do |level|
      print "\n    " + format(format, level.id, level.grade, level.cycle)
    end
    print "\n\n"
  end

  def display_teachers
    format = '%-5s %-15s %-15s %s'
    print "\n    " + format(format, 'Id', 'Firstname', 'Lastname', 'Amount of skills')
    @teachers.each do |teacher|
      print "\n    " + format(format, teacher.id, teacher.firstname, teacher.lastname, teacher.skills.count)
    end
    print "\n\n"
  end

  def display_requests
    format = '%-5s %-20s %-15s %-15s %-20s %-15s %-15s %-s'
    print "\n    " + format(format, 'Id', 'Client', 'Level', 'Field', 'Selected teacher', 'price_per_hour', 'nb courses', 'total_price')
    @requests.each do |request|
      print "\n    " + format(
        format,
        request.id,
        request.client_firstname + ' ' + request.client_lastname,
        request.level.grade + ' ' + request.level.cycle,
        request.field.name,
        request.selected_teacher.firstname + ' ' + request.selected_teacher.lastname,
        request.price_per_hour,
        request.courses.count,
        request.total_price
      )
    end
    print "\n\n"
  end

  private

  # Building methods

  def build_records
    @fields = build_fields_from_data
    @levels = build_levels_from_data
    @teachers = build_teachers_from_data
    @requests = build_requests_from_data
  end

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
    requests = requests_json.map do |h|
      Request.new(
        h['id'],
        h['client_firstname'],
        h['client_lastname'],
        @levels.select { |l| l.id == h['level'] }.first,
        @fields.select { |f| f.id == h['field'] }.first,
        @teachers.select { |t| t.id == h['selected_teacher'] }.first
      )
    end
    requests.sort_by!(&:id)
  end
end
