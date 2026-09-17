# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def logout
    sign_out

    redirect_to root_path, notice: t(".success")
  end

  def callback
    auth_user_info = auth[:info]

    user = User.find_or_initialize_by(email: auth_user_info[:email].downcase)
    user.name = auth_user_info[:name]
    user.admin = auth.dig(:extra, :admin) || false if user.new_record?

    if user.save
      sign_in user
      redirect_to root_path, notice: t(".success")
    else
      redirect_to new_user_path
    end
  end

  private

  def auth
    request.env["omniauth.auth"]
  end
end
