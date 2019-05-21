require 'test/unit'

class TestTeacher < Test::Unit::TestCase
  def setup
    @field1 = Field.new(1, 'mathematics')
    @field2 = Field.new(2, 'history')
    @level = Level.new(1, 'sixth', 'middle')
    @skill1 = { field: @field1, level: @level }
    @skill2 = { field: @field2, level: @level }
    @teacher = Teacher.new(1, 'Quentin', 'Potie', [@skill1, @skill2])
  end

  def test_new
    assert_equal(1, @teacher.id)
    assert_equal('Quentin', @teacher.firstname)
    assert_equal('Potie', @teacher.lastname)
    assert_send([@teacher.skills, :include?, @skill1])
    assert_send([@teacher.skills, :include?, @skill2])
  end

  def test_to_json
    assert_equal(
      {
        "id": 1,
        "firstname": "Quentin",
        "lastname": "Potie",
        "skills": [
          {
            field: 1,
            level: 1
          },
          {
            field: 2,
            level: 1
          }
        ]
      },
      @teacher.to_json        
    )
  end
end
