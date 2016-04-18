class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :digest_auth
  USERS = { 'cnosuke' => 'funhopw0123' }

  def now
    @now ||= Time.now
  end

  private

  def digest_auth
    return unless Rails.env.production?

    authenticate_or_request_with_http_digest do |user|
      USERS[user]
    end
end
