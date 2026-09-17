# frozen_string_literal: true

class Web::UsersController < Web::ApplicationController
  def new
    @user = User.new
  end
end
