# frozen_string_literal: true

class Web::Admin::ApplicationController < Web::ApplicationController
  before_action :require_admin!
end
