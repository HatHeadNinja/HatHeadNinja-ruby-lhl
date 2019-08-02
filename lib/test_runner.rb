require 'rspec'
require 'tempfile'
require 'json'
require 'faraday'
require 'digest'

class TestRunner
  EXAM_CODE = 'web-06'
  EXAM_HOST = 'http://localhost:3000'
  SUBMISSION_PATH = "#{EXAM_HOST}/submissions"

  def self.run(question_number)
    TestRunner.new(question_number).run
  end

  def initialize question_number
    @start_time = Time.new
    @number = question_number
    @out_file = Tempfile.new('rspec_out')
    @err_file = Tempfile.new('rspec_err')
  end

  def run
    @exitCode = RSpec::Core::Runner.run([test_file, '-f', 'j'], @err_file, @out_file)
    @end_time = Time.new

    resp = report_results

    if resp.status === 200 then
      pp resp.body
    end

    cleanup
  end

  private

  def report_results
    Faraday.post(SUBMISSION_PATH) do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = request_body.to_json
    end
  end

  def rspec_results
    @rspec_results ||= @out_file.rewind && JSON.parse(@out_file.read)
  end

  def rspec_errors
    @err_file.rewind
    @err_file.read
  end

  def test_file
    "tests/test_#{padd_number}.rb"
  end

  def padd_number
    if @number < 10 then
      "0#{@number}"
    else
      "#{@number}"
    end
  end

  def request_body
    {
      examId: 'web-06',
      questionNumber: @number,
      lintResults: nil,
      testResults: test_results,
      testFileHash: test_file_hash,
      studentCode: student_code,
      errors: test_errors,
      studentId: student_id
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
    if @exitCode == 0 then
      return []
    end

    rspec_results["examples"].map { |example| example["exception"] }.filter { |error| error != nil }
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
    [@out_file, @err_file].each do |file|
      file.close
      file.unlink
    end
  end
end

