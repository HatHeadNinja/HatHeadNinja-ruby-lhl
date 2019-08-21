require 'rspec'
require 'json'
require 'digest'
require_relative './api'
require_relative './config'

class TestRunner
  def self.run(question_number)
    TestRunner.new(question_number).run
  end

  def initialize question_number
    @start_time = Time.new
    @number = question_number
    @config = Config.new
  end

  def run
    runner_conf = RSpec::Core::ConfigurationOptions.new([test_file, '-f', 'doc', '-f', 'j', '--out', 'report.json'])
    runner = RSpec::Core::Runner.new(runner_conf)
    @exitCode = runner.run($stdout, $stderr)
    @end_time = Time.new

    begin    
      results = report_results

      print_results results
    rescue API::SubmissionError => e
      puts e.message
    end
    
    cleanup
  end

  private

  def print_results results
    puts "Overall Score"
    puts "------------"
    
    questions = results["scores"]
    questions.each do |q|
      puts "Q#{q["questionNumber"]}. #{q["score"]}/#{q["maxScore"]}"
    end

    puts

    time_remaining = results["remainingTime"]
    if time_remaining > 0
      hours = (time_remaining / 60).floor
      minutes = (time_remaining % 60).floor

      puts "Time Remaining: #{hours}h#{minutes}"
    else
      puts "Time Remaining: None (Submission still accepted)"
    end
  end

  def report_results
    API.submit_results request_body
  end

  def rspec_results
    @rspec_results ||= JSON.parse(out_file.read)
  end

  def test_file
    "tests/test_#{padd_number}.rb"
  end

  def padd_number
    if @number < 10
      "0#{@number}"
    else
      "#{@number}"
    end
  end

  def out_file
    @out_file ||= File.open('./report.json', 'r')
  end

  def request_body
    {
      examId: @config.exam_code,
      questionNumber: @number,
      lintResults: nil,
      testResults: test_results,
      testFileHash: test_file_hash,
      studentCode: student_code,
      errors: test_errors,
      studentId: @config.student_id
    }
  end

  def test_results
    total = rspec_results["summary"]["example_count"]
    failures = rspec_results["summary"]["failure_count"]
    passes = total - failures
    pending = rspec_results["summary"]["pending_count"]
    {
      suites: 1,
      tests: total,
      passes: passes,
      pending: pending,
      failures: failures,
      start: @start_time.to_s,
      end: @end_time.to_s,
      duration: rspec_results["summary"]["duration"]
    }
  end

  def test_errors
    return [] if @exitCode == 0

    rspec_results["examples"].map { |example| example["exception"] }.reject { |error| error.nil? }
  end

  def student_id
    File.open('.student-id', 'r').read.chomp
  end

  def student_code
    @student_code ||= File.open("answers/#{padd_number}.rb", 'r').read
  end

  def test_file_hash
    test_file_content = File.open(test_file, 'r').read
    Digest::MD5.hexdigest test_file_content
  end

  def cleanup
    out_file.close
    File.delete(out_file.path)
  end
end

