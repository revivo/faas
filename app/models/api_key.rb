class ApiKey < ActiveRecord::Base
  attr_accessible :apikey
  validates_presence_of :apikey
  validates_uniqueness_of :apikey
end
