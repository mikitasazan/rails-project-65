# frozen_string_literal: true

class Web::ProfilesController < Web::ApplicationController
  before_action :require_signed_in_user!

  def show
    @bulletins = current_user.bulletins.order(updated_at: :desc)
  end
end
