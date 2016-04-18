class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate
  USERS = { 'cnosuke' => 'funhopw0123' }.freeze
  API_TOKENS = [
    "V6n7CJnAWP87Cwbuvd7jIfuwjTBgDAmB3DAfuQf5dHMOtYDe3UUhN42z4msauLbT",
    "rtMzwdUIqoRm8JIpjxmSWmpYOKlD3Pz2CDpdn4i9lDe9tIfHfqaPrOJTXnMLVFam",
    "bWycMpLVjY2s39VxJZQkct1M0CWSq7vqh3OFUZ8DCE46wj6KYJIK70OftiUESN4S",
  ].freeze

  def now
    @now ||= Time.now
  end

  private

  def authenticate
    return unless Rails.env.production?

    authenticate_api || authenticate_pc
  end

  def authenticate_api
    API_TOKENS.include?(params['api_token'])
  end

  def authenticate_pc
    authenticate_or_request_with_http_digest do |user|
      USERS[user]
    end
  end
end
