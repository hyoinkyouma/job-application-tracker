class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token
  
  def google_oauth2
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env["omniauth.auth"])
      auth = request.env["omniauth.auth"]
      
      if @user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        @user[:auth_key_google] = auth.credentials.token
        @user[:auth_google_expiry ]= auth.credentials.expires_at
        @user[:auth_google_refresh_token] = auth.credentials.refresh_token
        @user.save!
        sign_in_and_redirect @user, event: :authentication
    
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
  end
end
  