# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
FaaS::Application.initialize!

# set app env
ENV['RAILS_ENV'] = 'development'

DATA_ROOT = './folders'
ENV['faas_api_version'] = 'v1.0'
ENV['faas_instance_url'] = 'http://localhost'
