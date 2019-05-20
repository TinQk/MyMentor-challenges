class Request
  attr_reader :id, :client_full_name, :level, :field

  def initialize(id, client_full_name, level, field)
    @id = id
    @client_full_name = client_full_name
    @level = level
    @field = field
  end

  def to_json
    {
      id: id,
      client_full_name: client_full_name,
      level: level.id,
      field: field.id
    }
  end

  private

  attr_writer :id, :client_full_name, :level, :field
end
