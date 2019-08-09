require 'yaml'

class Config
  class ConfigLoadError < StandardError; end;

  attr_reader :student_id, :exam_code

  def initialize
    config = YAML.load_file('./config.yml')
    if config["student_id"].nil?
      raise ConfigLoadError, "Enter a unique Student Id in the file config.yml"
    elsif config["exam_code"].nil?
      raise ConfigLoadError, "Enter a valid exam code in the file config.yml"        
    end

    @student_id = config["student_id"]
    @exam_code = config["exam_code"]
  end
end
