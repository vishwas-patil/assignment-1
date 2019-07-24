# frozen_string_literal: true

#:nodoc:
class HomeController < ApplicationController
  def missing_path
    error_response
  end
end
