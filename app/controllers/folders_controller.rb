require 'folders'

class FoldersController < ApplicationController

  respond_to :json

  def index
  end

  def create_folder
    @json = Folders.create_folder(params[:id])
    render :json => @json
  end

  def show
    @json = Folders.list_all_folders(params[:id])
    render :json => @json
  end

  def get_api_key
    @json = Folders.api_key
    render :json => @json
  end

  def set_content
    @json = Folders.store_data_in_folder(params[:id], {'folder_name' => params[:folder_name], 'data' => params[:message]})
    render :json => @json
  end

  def show_api_doc
   @json = {
       :appName => 'FaaS(Folder as a service)',
       :organization => 'Rearden Commerce Inc.',
       :copyright => 'Rearden Commerce Inc.',
       :date => '26 March 2013',
       :devel => 'Internal Apps',
       :email => 'InternalApps@deem.com',
       :description => '
        Pitstop day project commemorating the divinity of folders.
        A simple Rails 3.2 app which creates folders and allows you to store anything (read upto 141 characters).
        Why 141 characters? Because we are not twitter :).
        Think of it as our internal buckets similar to Amazon S3.
        It is UI less and only accessible through REST at this point.
        Yes, the *not* so much exciting json will greets you for some time till I make it UI-ful.
        User identification is via API Keys only.
        FaaS uses Sqlite3 (dev) and pg(prod) and creates just one table for storing api keys.
        All folders are created under APP_ROOT/folders.',
       :github => 'https://github.com/revivo/faas.git',
       :apidoc => {
            'create api key' => 'https://blooming-tundra-4394.herokuapp.com/apikey',
            'create folder' => 'https://blooming-tundra-4394.herokuapp.com/folders/<apikey>/create',
            'list all folders'=> 'https://blooming-tundra-4394.herokuapp.com/folders/<apikey>',
            'store 141 char data in folder' => 'https://blooming-tundra-4394.herokuapp.com/folders/<apikey>/store/<folder_name>/<message>'
       }
   }
   render :json => @json
  end
end
