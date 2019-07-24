module V1
  class SearchController < ApplicationController
    before_action :authorize_user!

    # GET /reviews
    def search
      search_param = params[:name]
      @search_result = Author.search(search_param).uniq + Book.search(search_param).uniq + Review.search(search_param).uniq

      return not_found unless @search_result.size > 0

      json_response(@search_result)
    end
  end
end