class Level
  attr_reader :id, :grade, :cycle

  def initialize(id, grade, cycle)
    @id = id
    @grade = grade
    @cycle = cycle
  end

  private
  attr_writer :id, :grade, :cycle
end
