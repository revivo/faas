require 'utils'
require 'json'
require 'httparty'

# Folders class does all the heavy lifting of this app
class Folders
  include HTTParty
  format :json

  def self.root_url
    @root_url = ENV['faas_instance_url']+"/services/data/v"+ENV['faas_api_version']
  end

  def self.api_key
    headers 'Content-Type' => "application/json"
    kkey = generate_api_key()
    ApiKey.create({:apikey => kkey})
    options = {
        :body => {
            :api_key => kkey,
            :message => "API Key successfully generated. Save this for all future calls."
        }.to_json
    }
    response = post(Folders.root_url, options)
  end

  def self.create_folder(apikey)
    headers 'Content-Type' => "application/json"

    unless ApiKey.exists?(apikey)
      ApiKey.create({:apikey => apikey})
      # create root folder for the api key user identified by the apikey
      unless FileTest::directory?(File.join(DATA_ROOT, apikey))
        Dir::mkdir(File.join(DATA_ROOT, apikey))
        # create unique folder
        folder = generate_uuid()
        # add a folder under apikey_root folder
        Dir::mkdir(File.join(DATA_ROOT, apikey, folder))
        options = {
            :body => {
                :folder => folder,
                :message => "Folder successfully created."
            }.to_json
        }
        response = post(Folders.root_url, options)
      else
        # api key exists in db
        # should also exist in file path
        # still check
        if FileTest::directory?(File.join(DATA_ROOT, apikey))
          # create unique folder
          folder = generate_uuid()
          # add a folder under apikey_root folder
          Dir::mkdir(File.join(DATA_ROOT, apikey, folder))
        else
          # create apikey root dir
          Dir::mkdir(File.join(DATA_ROOT, apikey))
          # create unique folder
          folder = generate_uuid()
          # add a folder under apikey_root folder
          Dir::mkdir(File.join(DATA_ROOT, apikey, folder))
          #TODO: return success json
        end
      end
    else
      #TODO: return failure json
    end
  end
end