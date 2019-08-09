require 'faraday'
require 'json'

module API
  API_HOST = 'http://localhost:3000'
  EXAM_START_PATH = "#{API_HOST}/exams"
  SUBMISSION_PATH = "#{API_HOST}/submissions"

  class StartExamError < StandardError; end
  class SubmissionError < StandardError; end

  def self.start_exam exam_code, student_id
    uri = "#{EXAM_START_PATH}/#{exam_code}"
    
    resp = Faraday.post(uri) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = { studentId: student_id }.to_json
    end

    if resp.status == 400
      raise StartExamError, resp.body
    end

    JSON.parse(resp.body)
  end

  def self.submit_results request_body
    resp = Faraday.post(SUBMISSION_PATH) do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = request_body.to_json
    end

    if resp.status != 200
      raise SubmissionError, resp.body
    end

    JSON.parse(resp.body)
  end
end
