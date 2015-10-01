class HomeController < ApplicationController
  def index
    @selected_account = selected_account
    redirect_to real_time_stats_path
  end
end
