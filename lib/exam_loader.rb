require_relative './api'
require_relative './config'

module ExamLoader
  def self.load
    # Read student ID file
    begin
      config = Config.new
    rescue Config::ConfigLoadError => e
      puts e.message
      return false
    end

    puts "Contacting Server to Start Exam \"#{config.exam_code}\""
    puts

    begin
      json = API.start_exam config.exam_code, config.student_id
      write_exam json  
    rescue API::StartExamError => e
      puts e.message
      return false
    end

    # Print empty line
    puts ""
  end

  def self.write_exam exam
    questions = exam["questions"]
    puts "Server Response: #{questions.count} Questions:\n"

    questions.each do |q|
      code_path = q["codePath"]
      code_content = q["code"]

      test_path = q["testPath"]
      test_content = q["testCode"]

      puts "\tCreating Question #{q['questionId']}\t (#{q['maxScore']} Points)\tAnswer file: #{code_path}"

      File.open(code_path, 'w') do |f|
        f.puts code_content
      end

      File.open(test_path, 'w') do |f|
        f.puts test_content
      end
    end
  end
end
