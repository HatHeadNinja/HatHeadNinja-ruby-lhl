# frozen_string_literal: true

require 'faraday'
require 'json'

module API
  API_HOST = 'https://lighthouse-proctologist.herokuapp.com'
  EXAM_PATH = "#{API_HOST}/api/v2/exams"

  class StartExamAuthorizationError < StandardError; end
  class StartExamForbiddenError < StandardError; end
  class SubmissionError < StandardError; end

  def self.start_exam(exam_token)
    resp = Faraday.get(EXAM_PATH) do |req|
      req.headers['Authorization'] = "Bearer #{exam_token}"
    end
    json = JSON.parse(resp.body)

    case resp.status
    when 401
      raise StartExamAuthorizationError, json['error']
    when 403
      raise StartExamForbiddenError, json['error']
    end

    json
  end

  def self.submit_results(request_body, exam_id, exam_token)
    url = "#{EXAM_PATH}/#{exam_id}"
    resp = Faraday.post(url) do |req|
      req.headers['Authorization'] = "Bearer #{exam_token}"
      req.headers['Content-Type'] = 'application/json'
      req.body = request_body.to_json
    end

    if resp.status != 200
      raise SubmissionError, resp.body
    end

    JSON.parse(resp.body)
  end
end
