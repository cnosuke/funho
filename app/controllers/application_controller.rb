class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate

  USERS = { ENV['DIGEST_USER'] => ENV['DIGEST_PASSWORD'] }.freeze

  def now
    @now ||= Time.now
  end

  private

  def authenticate
    return unless Rails.env.production?
    authenticate_pc
  end

  def authenticate_pc
    authenticate_or_request_with_http_digest do |user|
      USERS[user]
    end
  end
end
