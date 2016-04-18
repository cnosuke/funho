class ApiController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :authenticate

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
    authenticate_api
  end

  def authenticate_api
    API_TOKENS.include?(params['api_token'])
  end
end
