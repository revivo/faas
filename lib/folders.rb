require 'utils'
require 'json'
require 'httparty'

# Folders class does all the heavy lifting of this app
class Folders
  include HTTParty
  format :json
  default_params :output => 'json'
  base_uri 'splinter.com'

  def self.root_url
    @root_url = "http://localhost:3000" #File.join(ENV['faas_instance_url'], ENV['faas_api_version'])
  end

  def self.api_key
    headers 'Content-Type' => "application/json"
    kkey = generate_api_key()
    ApiKey.create({:apikey => kkey})
    options = {
      :api_key => kkey,
      :message => "API Key successfully generated. Save this for all future calls."
    }
    return options
  end

  def self.create_folder(apikey)
    unless ApiKey.exists?(apikey)
      ApiKey.create({:apikey => apikey})
      # create root folders for the api key user identified by the apikey
      unless FileTest::directory?(File.join(DATA_ROOT, apikey))
        Dir::mkdir(File.join(DATA_ROOT)) unless FileTest::directory?(File.join(DATA_ROOT))
        Dir::mkdir(File.join(DATA_ROOT, apikey))
        # create unique folders
        folder = generate_uuid()
        # add a folders under apikey_root folders
        Dir::mkdir(File.join(DATA_ROOT, apikey, folder))
        options = {
          :apikey => apikey,
          :folders => folder,
          :message => "Folder successfully created."
        }
        return options
      else
        # api key exists in db
        # should also exist in file path
        # still check
        if FileTest::directory?(File.join(DATA_ROOT, apikey))
          # create unique folders
          folder = generate_uuid()
          # add a folders under apikey_root folders
          Dir::mkdir(File.join(DATA_ROOT, apikey, folder))
          options = {
              :apikey => apikey,
              :folders => folder,
              :message => "Folder successfully created."
          }
          return options
        else
          # create apikey root dir
          Dir::mkdir(File.join(DATA_ROOT, apikey))
          # create unique folders
          folder = generate_uuid()
          # add a folders under apikey_root folders
          Dir::mkdir(File.join(DATA_ROOT, apikey, folder))
          options = {
              :apikey => apikey,
              :folders => folder,
              :message => "Folder successfully created."
          }
          return options
        end
      end
    else
      options = {
          :apikey => apikey,
          :message => "Api key not found. Folder couldn't be created."
      }
      return options
    end
  end
end