class Teacher
  attr_reader :id, :firstname, :lastname, :skills

  def initialize(id, firstname, lastname, skills = [])
    @id = id
    @firstname = firstname
    @lastname = lastname
    @skills = skills
  end

  def to_json
    {
      id: self.id,
      firstname: self.firstname,
      lastname: self.lastname,
      skills: self.skills.map { |h| h.transform_values(&:id) }
    }
  end

  private
  attr_writer :id, :firstname, :lastname, :skills
end
