class TeacherMenu
  attr_accessor :data_filename

  def initialize(data_filename:)
    @data_filename = data_filename
    # build teachers records from json
    @fields = build_fields_from_data
    @levels = build_levels_from_data
    @teachers = build_teachers_from_data
  end

  def call
    printf "
    - TEACHERS MANAGEMENT -

    What do you want to do ?
    1. Display registered teachers
    2. Add a new teacher
    3. Update a teacher' skills
    4. Delete a teacher
    5. Save modifications
    6. Go back to main menu
    "

    case answer = gets.chomp
    when "1" then display_teachers()
    when "2" then add_new_teacher()
    when "3" then
      display_teachers()
      return update_teacher_skills(select_teacher())
    when "4" then
      display_teachers()
      delete_teacher(select_teacher())
    when "5" then rewrite_teachers()
    when "6" then return MainMenu.new(data_filename: @data_filename).call
    else print "Please enter a valid command."
    end

    return call()
  end

  def add_new_teacher
    # Auto choose id
    if @teachers.empty? then id = 1 else id = @teachers.last.id + 1 end
    print "Teacher's firstname ?"; fn = gets.chomp
    print "Teacher's lastname ?"; ln = gets.chomp
    # Create teacher
    @teachers << t = Teacher.new(id, fn, ln)
    p "Do you want to add skills to the teacher ? y/n "
    add_skills_to_teacher(t) if gets.chomp == "y"
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

  def add_skills_to_teacher(teacher)
    display_fields
    print "what field does (s)he teach ? Enter a number"; answer = gets.chomp
    field = @fields.select { |f| f.id == answer.to_i }.first
    display_levels
    print "At which level does (s)he teach #{field.name} ? Enter a number"; answer = gets.chomp
    level = @levels.select { |l| l.id == answer.to_i }.first
    skill = {field: field, level: level}
    if teacher.skills.include?(skill) then p "he already knows that !"
    else teacher.skills << skill
    end
    print "Do you want to add another skill to the teacher ? y/n "
    add_skills_to_teacher(teacher) if gets.chomp == "y"
  end

  def remove_skills_to_teacher(teacher)
    display_skills(teacher)
    print "Which skill do you want to delete ? Enter a number"; index = gets.chomp
    teacher.skills.delete_at(index.to_i - 1)
    print "skill deleted"
  end

  def update_teacher_skills(teacher)
    printf "
    - Teacher : #{teacher.firstname} #{teacher.lastname} -

    What do you want to do ?
    1. Display skills
    2. Add a new skill
    3. Delete a skill
    4. Go back to TEACHER MANAGEMENT
    "
    case answer = gets.chomp
    when "1" then display_skills(teacher)
    when "2" then add_skills_to_teacher(teacher)
    when "3" then remove_skills_to_teacher(teacher)
    when "4" then return call()
    else print "Please enter a valid command."
    end

    return update_teacher_skills(teacher)
  end

  def delete_teacher(teacher)
    print "Do you really want to delete #{teacher.firstname} #{teacher.lastname} ? y/n "
    case answer = gets.chomp
      when "y" then
        @teachers -= [teacher]
        print "Teacher deleted, don't forget to save your changes"
      when "n" then return call
      else print "Invalid command"
      return call
    end
  end

  def select_teacher
    print "Enter the id of the teacher (enter 's' to show teachers)"
    case answer = gets.chomp.to_i
      when "s" then display_teachers; return select_teacher
      else return @teachers.select { |t| t.id == answer.to_i }.first
    end
  end

  def rewrite_teachers
    output = open_and_parse_data
    output["teachers"] = @teachers.map { |t| t.to_json }

    File.open(@data_filename,'w') do |f|
      f.write(JSON.pretty_generate(output))
    end

    p "Saved in JSON"
  end

  def display_teachers
    format = '%-5s %-15s %s'
    print "\n    " + format % ['Id', 'Firstname', 'Lastname']
    @teachers.each do |teacher|
      print "\n    " + format % [ teacher.id, teacher.firstname, teacher.lastname ]
    end
    print "\n\n"
  end

  def display_skills(teacher)
    teacher.skills.each_with_index do |hash, i|
      print "\n SKILL #{i+1} --> Field : #{hash[:field].name}, Grade : #{hash[:level].grade}, Cycle : #{hash[:level].cycle}"
    end
    print "\n\n"
  end

  def display_fields
    format = '%-5s %s'
    print "\n    " + format % ['Id', 'Name']
    @fields.each do |field|
      print "\n    " + format % [ field.id, field.name ]
    end
    print "\n\n"
  end

  def display_levels
    format = '%-5s %-15s %s'
    print "\n    " + format % ['Id', 'Grade', 'Cycle']
    @levels.each do |level|
      print "\n    " + format % [ level.id, level.grade, level.cycle ]
    end
    print "\n\n"
  end

  private

  def open_and_parse_data
    JSON.parse(File.read(@data_filename))
  end

  def build_teachers_from_data
    teachers_json = open_and_parse_data.fetch("teachers")
    teachers = teachers_json.map { |h| Teacher.new(
      h["id"], h["firstname"], h["lastname"],
      h["skills"].map { |h| { field: @fields.select { |f| f.id == h["field"] }.first, level: @levels.select { |l| l.id == h["level"] }.first } }
      ) }
    teachers.sort_by! { |t| t.id }
  end

  def build_fields_from_data
    fields = open_and_parse_data.fetch("fields")
    fields.map! { |h| Field.new(h["id"], h["name"]) }
    fields.sort_by! { |f| f.id }
  end

  def build_levels_from_data
    levels = open_and_parse_data.fetch("levels")
    levels.map! { |h| Level.new(h["id"], h["grade"], h["cycle"]) }
    levels.sort_by! { |l| l.id }
  end
end
