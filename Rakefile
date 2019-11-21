require_relative './lib/exam_loader'
require_relative './lib/test_runner'

namespace 'exam' do
  desc 'Start an exam'
  task :start, [:exam_token] do |t, args|
    if args[:exam_token].nil?
      abort "An exam token is required to start an exam\n" \
            "Please provide an exam token like the following:\n" \
            "\n  $ bundle exec rake start:exam[<EXAM_TOKEN>]\n"
    end

    if Dir['./answers/*'].count != 0 || Dir['./tests/*'].count != 0
      abort "Please make sure that the **answers** and **tests** directories\n" \
            "are empty before trying to start an exam!"
    end

    ExamLoader.load(args[:exam_token])
  end

  task :question, [:question_number] do |t, args|
    question_number = args[:question_number].to_i

    puts "Running Tests for Question #{question_number}"
    puts '------------'

    begin
      TestRunner.run(question_number)
    rescue StandardError => e
      puts e.message
    end
  end
end
