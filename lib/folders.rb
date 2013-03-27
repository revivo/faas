require 'utils'
require 'json'

# Folders class does all the heavy lifting of this app
class Folders

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
    Rails.logger.info "create_folder with api key = (#apikey.inspect)"
    unless ApiKey.exists?({:apikey => apikey})
      options = {
          :apikey => apikey,
          :message => "Api key not found. Folder couldn't be created."
      }
      Rails.logger.debug options.inspect
      return options
    else
      # api key exists in db
      # should also exist in file path
      # still check
      if FileTest::directory?(DATA_ROOT) and FileTest::directory?(File.join(DATA_ROOT, apikey))
        # create unique folders
        folder = generate_uuid()
        # add a folders under apikey_root folders
        Dir::mkdir(File.join(DATA_ROOT, apikey, folder))
        Rails.logger.info "Folder created."
        options = {
            :apikey => apikey,
            :folder => folder,
            :message => "Folder successfully created."
        }
        Rails.logger.debug options.inspect
        return options
      else
        # create apikey root dir
        Dir::mkdir(DATA_ROOT) unless FileTest::directory?(File.join(DATA_ROOT))
        Dir::mkdir(File.join(DATA_ROOT, apikey))
        # create unique folders
        folder = generate_uuid()
        # add a folders under apikey_root folders
        Dir::mkdir(File.join(DATA_ROOT, apikey, folder))
        Rails.logger.info "Folder created."
        options = {
            :apikey => apikey,
            :folder => folder,
            :message => "Folder successfully created."
        }
        Rails.logger.debug options.inspect
        return options
      end
    end
  end

  # store 141 char limited string in folder
  def self.store_data_in_folder(apikey, opts = {})
    Rails.logger.info "store_data_in_folder with api key = (#{apikey.inspect}) and opts = (#{opts.inspect})"
    unless ApiKey.exists?({:apikey => apikey})
      options = {
          :apikey => apikey,
          :message => "Api key not found."
      }
      Rails.logger.debug options.inspect
      return options
    end
    if opts.nil? or opts.blank?
        options = {
            :apikey => apikey,
            :message => "Missing arguments."
        }
        Rails.logger.debug options.inspect
        return options
    end
    if !opts.has_key?('folder_name') or opts['folder_name'].nil? or opts['folder_name'].blank?
        options = {
            :apikey => apikey,
            :message => "Please specify a valid folder name to store data."
        }
        Rails.logger.debug options.inspect
        return options
    end
    if !opts.has_key?('data') or opts['data'].nil? or opts['data'].blank? or opts['data'].length > GLOBALS::MAX_MESSAGE_LENGTH
      options = {
          :apikey => apikey,
          :message => "Data should be non empty and 141 character limited."
      }
      Rails.logger.debug options.inspect
      return options
    end
    unless FileTest::directory?(DATA_ROOT) and FileTest::directory?(File.join(DATA_ROOT, apikey)) and FileTest::directory?(File.join(DATA_ROOT, apikey, opts['folder_name']))
      options = {
          :apikey => apikey,
          :message => "Folder doesn't exist"
      }
      Rails.logger.debug options.inspect
      return options
    else
      data_file = generate_uuid()
      path = File.join(DATA_ROOT, apikey, opts['folder_name'], data_file)
      begin
        File.open(path, "w"){|file| file.write(opts['data'])}
        Rails.logger.info "data stored in file."
        options = {
            :apikey => apikey,
            :folder => opts['folder_name'],
            :file => data_file,
            :message => "Successfully stored message in folder."
        }
        Rails.logger.debug options.inspect
        return options
      rescue  => e
        Rails.logger.debug e.inspect
        return   {
            :apikey => apikey,
            :message => "Failed to write data to folder (#opts['folder_name']) due to exception."
        }
      end
    end
  end
end