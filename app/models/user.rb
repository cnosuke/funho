class User < ActiveRecord::Base
  has_many :tasks
  has_many :pomodoros
  has_many :timelines

  def self.create_with_omniauth(auth)
    create! do |u|
      u.provider         = auth[:provider]
      u.uid              = auth[:uid]
      u.name             = auth[:info][:name]
      u.email            = auth[:info][:email]
      u.image            = auth[:info][:image]
      u.token            = auth[:credentials][:token]
      u.token_expires_at = Time.at(auth[:credentials][:expires_at])
      u.api_token        = generate_api_token
    end
  end

  def self.generate_api_token
    SecureRandom.uuid
  end
end
