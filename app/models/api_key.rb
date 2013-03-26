class ApiKey < ActiveRecord::Base
  attr_accessible :apikey
  validates_presence_of :apikey
end
