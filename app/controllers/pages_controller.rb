class PagesController < ApplicationController
  def index
    redirect_to tasks_path
  end
end
