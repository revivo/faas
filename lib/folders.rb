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
    kkey = generate_api_key()
    ApiKey.create({:apikey => kkey})
    options = {
      :api_key => kkey,
      :message => "API Key successfully generated. Save this for all future calls."
    }
    return options
  end

  def self.list_all_folders(apikey)
    unless ApiKey.exists?({:apikey => apikey})
      options = {
          :apikey => apikey,
          :message => "Api key not found."
      }
    else
      unless FileTest::directory?(File.join(DATA_ROOT, apikey))
        options =   {
            :apikey => apikey,
            :message => "Missing root folder. Probably you didn't create it in first place."
        }
      else
        folders = Dir.glob(File.join(DATA_ROOT, apikey, '*')).select {|f| File.directory? f} | []
        folder_count = folders.length
        options =  {
            :apikey => apikey,
            :folder_count => folder_count,
            :folders => folders,
            :message => "Listing of all folders for the requester."
        }
      end
    end
  end

  def self.create_folder(apikey)
    unless ApiKey.exists?({:apikey => apikey})
      options = {
          :apikey => apikey,
          :message => "Api key not found. Folder couldn't be created."
      }
      return options
    else
      # api key exists in db
      # should also exist in file path
      # still check
      if FileTest::directory?(DATA_ROOT) && FileTest::directory?(File.join(DATA_ROOT, apikey))
        # create unique folders
        folder = generate_uuid()
        # add a folders under apikey_root folders
        Dir::mkdir(File.join(DATA_ROOT, apikey, folder))
        options = {
            :apikey => apikey,
            :folder => folder,
            :message => "Folder successfully created."
        }
        return options
      else
        # create apikey root dir
        Dir::mkdir(DATA_ROOT) unless FileTest::directory?(File.join(DATA_ROOT))
        Dir::mkdir(File.join(DATA_ROOT, apikey))
        # create unique folders
        folder = generate_uuid()
        # add a folders under apikey_root folders
        Dir::mkdir(File.join(DATA_ROOT, apikey, folder))
        options = {
            :apikey => apikey,
            :folder => folder,
            :message => "Folder successfully created."
        }
        return options
      end
    end
  end
end