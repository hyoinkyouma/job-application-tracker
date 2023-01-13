class AddAuthGoogleExpiryToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :auth_google_refresh_token, :string
    add_column :users, :auth_google_expiry, :string
  end
end
