class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i(callback)

  def callback
    user = begin
      User.find_by_provider_and_uid(
        auth['provider'], auth['uid']
      ) || User.create_with_omniauth(auth)
    end

    session[:user_id] = user.id

    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil

    redirect_to root_path
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
