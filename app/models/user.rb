class User < ApplicationRecord
   has_many :jobs
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]
  
  def self.from_omniauth(access_token)
    data = access_token.info
    users = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
     unless users
         users = User.create(
            email: data['email'],
            password: Devise.friendly_token[0,20],
         )
    end
    users
  end
end
