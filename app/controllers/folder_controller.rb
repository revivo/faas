require 'folders'

class FolderController < ApplicationController

  def index
  end

  def get_api_key
    @json = Folders.api_key
  end
end
