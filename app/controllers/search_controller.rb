class SearchController < ApplicationController
  # respond_to :json

  def search
    authorize :search
    @result = Search.find(params[:query], params[:scope], params[:page])
    respond_with @result
  end
end
