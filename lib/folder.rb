require 'utils'

class Folder
  # To change this template use File | Settings | File Templates.
  # Folder class does all the heavy lifting of this app

  def create_folder(apikey)
    unless key_exists?
      # create db entry
      ApiKey.create(:apikey => apikey)
      # create root folder for the api key user identified by the apikey
      unless FileTest::directory?(File.join(DATA_ROOT, apikey))
        Dir::mkdir(File.join(DATA_ROOT, apikey))
        # create unique folder
        folder = generate_uuid()
        # add a folder under apikey_root folder
        Dir::mkdir(File.join(DATA_ROOT, apikey, folder))
        #TODO: return success json
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