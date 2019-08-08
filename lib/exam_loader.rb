require 'faraday'
require 'json'

module ExamLoader
  EXAM_CODE = 'web-06'
  EXAM_HOST = 'http://localhost:3000'
  EXAM_START_PATH = "#{EXAM_HOST}/exams/#{EXAM_CODE}"

  def self.load
    # Read student ID file
    begin
      studentIdFile = File.open('./.student-id')
      studentId = studentIdFile.read.chomp
      studentIdFile.close
    rescue
      puts "Enter a unique Student Id in the file .student-id"
      return false
    end

    if studentId == "" then
      puts "Enter a unique Student Id in the file .student-id"
      return false
    end

    puts "Contacting Server to Start Exam \"#{EXAM_CODE}\""
    puts
    
    resp = Faraday.post(EXAM_START_PATH) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = { studentId: studentId }.to_json
    end
 
    if resp.status == 400
      puts resp.body
      return false
    end

    json = JSON.parse(resp.body)

    write_exam json

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
