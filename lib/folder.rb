class Folder
  # To change this template use File | Settings | File Templates.
  # Folder class does all the heavy lifting of this app

  def create_folder(apikey)
    unless key_exists?
      # create db entry
      key = ApiKey.create(:apikey => apikey)

      # create root folder for the api key user identified by the apikey


      # add folder under root
    else
    end
  end
end