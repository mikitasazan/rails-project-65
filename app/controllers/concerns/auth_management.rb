# frozen_string_literal: true

module AuthManagement
  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    reset_session
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = User.find_by(id: session[:user_id])
  end

  def require_signed_in_user!
    return if current_user

    redirect_back fallback_location: root_path, alert: t("layouts.web.flash.signed_in_user_only")
  end

  def require_admin!
    return if current_user&.admin?

    redirect_back fallback_location: root_path, alert: t("layouts.web.flash.admins_only")
  end
end
