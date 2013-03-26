#! /usr/bin/ruby -v
require 'securerandom'

# this is the utility file for the project
# contains all small utils which are used across the project

def generate_api_key
  generate_uuid
end

# returns 32 char guid
def generate_uuid
  return Digest::MD5.hexdigest "#{SecureRandom.hex(10)}-#{DateTime.now.to_s}"
end