# frozen_string_literal: true

class Web::ProfilesController < Web::ApplicationController
  before_action :require_signed_in_user!

  def show
  end
end
