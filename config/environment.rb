# Load the rails application
require File.expand_path('../application', __FILE__)

require 'logger'
require 'fileutils'

# Initialize the rails application
FaaS::Application.initialize!

# set app env
ENV['RAILS_ENV'] = 'production'

DATA_ROOT = './folders'
ENV['faas_api_version'] = 'v1.0'
ENV['faas_instance_url'] = 'http://localhost'


unless File.exists?('/var/log/faas/faas.log') && File.writable?('/var/log/faas/faas.log')
  begin
    Dir.mkdir('/var/log/faas') unless FileTest::directory?('/var/log/faas')
    FileUtils.touch('/var/log/faas/faas.log')
    Rails.logger = Logger.new('/var/log/faas/faas.log')
  rescue => e
    Rails.logger = Logger.new(STDOUT)
    p '###' + e.inspect
  end
end
Rails.logger.level = 0

module GLOBALS
  MAX_MESSAGE_LENGTH = 141
end
