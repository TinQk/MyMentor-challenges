class Request
  attr_reader :id, :client_firstname, :client_lastname, :level, :field, :selected_teacher

  def initialize(id, client_firstname, client_lastname, level, field, selected_teacher = nil)
    @id = id
    @client_firstname = client_firstname
    @client_lastname = client_lastname
    @level = level
    @field = field
    @selected_teacher = selected_teacher
  end

  def to_json
    {
      id: id,
      client_firstname: client_firstname,
      client_lastname: client_lastname,
      level: level.id,
      field: field.id,
      selected_teacher: selected_teacher.id
    }
  end

  private

  attr_writer :id, :client_firstname, :client_lastname, :level, :field, :selected_teacher
end
