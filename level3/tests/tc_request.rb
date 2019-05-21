require 'test/unit'
require 'date'

class TestRequest < Test::Unit::TestCase
  def setup
    @field1 = Field.new(1, 'mathematics')
    @field2 = Field.new(2, 'history')
    @level = Level.new(1, 'sixth', 'middle')
    @skill1 = { field: @field1, level: @level }
    @skill2 = { field: @field2, level: @level }
    @teacher = Teacher.new(1, 'Quentin', 'Potie', [@skill1, @skill2])
    @course = { date: "2019-01-01", length: 2 }
    @request = Request.new(1, 'John', 'Doe', @level, @field1, @teacher, 20, [@course])
  end

  def test_new
    assert_equal(1, @request.id)
    assert_equal('John', @request.client_firstname)
    assert_equal('Doe', @request.client_lastname)
    assert_equal(@level, @request.level)
    assert_equal(@field1, @request.field)
    assert_equal(@teacher, @request.selected_teacher)
  end

  def test_to_json
    assert_equal(
      {
        "id": 1,
        "client_firstname": "John",
        "client_lastname": "Doe",
        "level": 1,
        "field": 1,
        "selected_teacher": 1,
        "price_per_hour": 20,
        "courses": [
          {
            "date": "2019-01-01",
            "length": 2
          }
        ]
      },
      @request.to_json
    )
  end

  def test_total_price
    assert_equal(40, @request.total_price)
  end
end
