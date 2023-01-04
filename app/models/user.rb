class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable

  def self.from_omniauth(access_token)
    data = access_token.info
    token = access_token.credentials['token']
    users = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
     unless users
         users = User.create(
            email: data['email'],
            password: Devise.friendly_token[0,20],
            auth_key_google: token
         )
    end
    users
  end
end
