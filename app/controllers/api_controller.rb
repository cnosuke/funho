class ApiController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :authenticate

  API_TOKENS = ENV['API_TOKENS'].split(',').freeze

  def now
    @now ||= Time.now
  end

  private

  def authenticate
    return unless Rails.env.production?
    authenticate_api
  end

  def authenticate_api
    API_TOKENS.include?(params['api_token'])
  end
end
