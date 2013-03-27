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
end
