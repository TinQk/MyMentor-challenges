class Request
  attr_reader :id, :client_firstname, :client_lastname, :level, :field, :selected_teacher, :price_per_hour, :courses

  def initialize(id, client_firstname, client_lastname, level, field, selected_teacher = nil, price_per_hour = nil, courses = [])
    @id = id
    @client_firstname = client_firstname
    @client_lastname = client_lastname
    @level = level
    @field = field
    @selected_teacher = selected_teacher
    @courses = courses
    @price_per_hour = price_per_hour
  end

  def to_json
    {
      id: id,
      client_firstname: client_firstname,
      client_lastname: client_lastname,
      level: level.id,
      field: field.id,
      selected_teacher: selected_teacher.id,
      price_per_hour: price_per_hour,
      courses: courses
    }
  end

  def total_price
    hours = 0
    courses.each do |h|
      hours += h[:length]
    end
    price_per_hour ? hours * price_per_hour : 0
  end

  private

  attr_writer :id, :client_firstname, :client_lastname, :level, :field, :selected_teacher
end
