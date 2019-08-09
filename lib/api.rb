require 'faraday'
require 'json'

module API
  API_HOST = 'http://localhost:3000'
  EXAM_START_PATH = "#{API_HOST}/exams"

  class StartExamError < StandardError; end

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

  def self.submit_results exam_code
  end
end
