class TeacherMenu < Menu
  # MAIN MENU

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

    case gets.chomp
    when '1'
      display_teachers
    when '2'
      add_new_teacher
    when '3'
      display_teachers
      return update_teacher_skills(select_teacher)
    when '4'
      display_teachers
      delete_teacher(select_teacher)
    when '5'
      rewrite_teachers
    when '6'
      return MainMenu.new(data_filename: @data_filename).call
    else
      print 'Please enter a valid command.'
    end

    call
  end

  private

  # METHODS RELATED TO TEACHERS

  def add_new_teacher
    # Auto choose id
    id = @teachers.empty? ? 1 : @teachers.last.id + 1

    # Ask for new teacher's name
    print "Teacher's firstname ?"; fn = gets.chomp
    print "Teacher's lastname ?"; ln = gets.chomp

    # Create teacher
    @teachers << t = Teacher.new(id, fn, ln)
    p 'Do you want to add skills to the teacher ? y/n '
    add_skills_to_teacher(t) if gets.chomp == 'y'

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

  def delete_teacher(teacher)
    print "Do you really want to delete #{teacher.firstname} #{teacher.lastname} ? y/n "
    case gets.chomp
    when 'y' then
      @teachers -= [teacher]
      print "Teacher deleted, don't forget to save your changes"
    when 'n' then return call
    else print 'Invalid command'
         return call
    end
  end

  def select_teacher
    print "Enter the id of the teacher (enter 's' to show teachers)"
    case answer = gets.chomp.to_i
    when 's'
      display_teachers
      return select_teacher
    else return @teachers.select { |t| t.id == answer.to_i }.first
    end
  end

  # METHODS RELATED TO SKILLS

  def update_teacher_skills(teacher)
    printf "
    - Teacher : #{teacher.firstname} #{teacher.lastname} -

    What do you want to do ?
    1. Display skills
    2. Add a new skill
    3. Delete a skill
    4. Go back to TEACHER MANAGEMENT
    "
    case gets.chomp
    when '1'
      display_skills(teacher)
    when '2'
      add_skills_to_teacher(teacher)
    when '3'
      remove_skills_from_teacher(teacher)
    when '4'
      return call
    else
      print 'Please enter a valid command.'
    end

    update_teacher_skills(teacher)
  end

  def add_skills_to_teacher(teacher)
    # Ask for the skill's field
    display_fields
    print 'what field does (s)he teach ? Enter a number'
    answer = gets.chomp
    field = @fields.select { |f| f.id == answer.to_i }.first

    # Ask for the skill's level
    display_levels
    print "At which level does (s)he teach #{field.name} ? Enter a number"
    answer = gets.chomp
    level = @levels.select { |l| l.id == answer.to_i }.first

    # Assemble skill and link it to the teacher
    skill = { field: field, level: level }
    teacher.skills.include?(skill) ? (p 'he already knows that !') : teacher.skills << skill

    print 'Do you want to add another skill to the teacher ? y/n '
    add_skills_to_teacher(teacher) if gets.chomp == 'y'
  end

  def remove_skills_from_teacher(teacher)
    display_skills(teacher)
    print 'Which skill do you want to delete ? Enter a number'
    index = gets.chomp
    teacher.skills.delete_at(index.to_i - 1)
    print 'skill deleted'
  end

  def display_skills(teacher)
    teacher.skills.each_with_index do |hash, i|
      print "\n SKILL #{i + 1} --> Field : #{hash[:field].name}, Grade : #{hash[:level].grade}, Cycle : #{hash[:level].cycle}"
    end
    print "\n\n"
  end

  # SAVE IN JSON

  def rewrite_teachers
    output = open_and_parse_data
    output['teachers'] = @teachers.map(&:to_json)

    File.open(@data_filename, 'w') do |f|
      f.write(JSON.pretty_generate(output))
    end

    p 'Saved in JSON'
  end
end
