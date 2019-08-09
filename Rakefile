require_relative './lib/exam_loader'
require_relative './lib/test_runner'

namespace "exam" do
  desc "Start an exam"
  task :start do
    ExamLoader.load
  end

  task :question, [:question_number] do |t, args|
    question_number = args[:question_number].to_i
    
    puts "Running Tests for Question #{question_number}"
    puts "------------"
    
    begin
      TestRunner.run(question_number)
    rescue e
      puts e.message
    end
  end
end
