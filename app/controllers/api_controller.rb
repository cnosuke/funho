class ApiController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :authenticate

  def now
    @now ||= Time.now
  end

  private

  def authenticate
    unless current_user.present?
      head :forbidden
    end
  end

  def current_user
    @current_user ||= User.find_by_api_token(params[:api_token])
  end

  helper_method :current_user
end
