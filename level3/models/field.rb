class Field
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  private

  attr_writer :id, :name
end
