require_relative './api'
require_relative './config'

module ExamLoader
  def self.load(token)
    puts "Contacting Server to Start Exam with token: \"#{token}\""
    puts

    begin
      json = API.start_exam token
      write_exam json
    rescue API::StartExamAuthorizationError => e
      puts 'Token seems to be missing'
      puts 'Please make sure you enter it along with this command'
      puts '  $ bundle exec rake exam:start[<EXAM_TOKEN>]'
      puts "Server Error: #{e.message}"
      return false
    rescue API::StartExamForbiddenError => e
      puts 'Invalid token!'
      puts 'Please make sure you have started the exam from compass.'
      puts "Server Error: #{e.message}"
    end

    # Print empty line
    puts ''
  end

  def self.write_exam(exam)
    questions = exam['questions']
    puts "Server Response: #{questions.count} Questions:\n"

    questions.each do |q|
      code_path = q['codePath']
      code_content = q['code']

      test_path = q['testPath']
      test_content = q['testCode']

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
